import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from scipy.sparse.linalg import spsolve, gmres, spilu, LinearOperator

# -----------------------------
# Helper: derivatives of a(x)
# -----------------------------
def compute_a_prime(a_vals, h):
    """4th-order accurate derivative of a at nodes using wide central formulas.
       a_vals length = N+1 corresponding to xs = 0..1.
    """
    N = len(a_vals)-1
    ap = np.zeros_like(a_vals)
    # 4th-order central for i=2..N-2
    for i in range(2, N-1):
        ap[i] = (-a_vals[i+2] + 8*a_vals[i+1] - 8*a_vals[i-1] + a_vals[i-2]) / (12.0*h)
    # one-sided 4th-order at left boundary (i=0,1)
    ap[0] = (-25*a_vals[0] + 48*a_vals[1] - 36*a_vals[2] + 16*a_vals[3] - 3*a_vals[4])/(12.0*h)
    ap[1] = (-3*a_vals[0] - 10*a_vals[1] + 18*a_vals[2] - 6*a_vals[3] + a_vals[4])/(12.0*h)
    # one-sided 4th-order at right boundary
    ap[N-1] = (3*a_vals[N] + 10*a_vals[N-1] - 18*a_vals[N-2] + 6*a_vals[N-3] - a_vals[N-4])/(12.0*h)
    ap[N]   = (25*a_vals[N] - 48*a_vals[N-1] + 36*a_vals[N-2] - 16*a_vals[N-3] + 3*a_vals[N-4])/(12.0*h)
    return ap

# -----------------------------
# Build matrix A and RHS b
# -----------------------------
def assemble_system(a_func, f_func, alpha, beta, N):
    """
    Assemble A and b so that (1/(720*h^2)) * A * u_inner = f_inner,
    where u_inner contains u1..u_{N-1}. Return (A_csr, b, xs).
    """
    h = 1.0 / N
    xs = np.linspace(0.0, 1.0, N+1)
    a_vals = a_func(xs)
    f_vals = f_func(xs)

    # stencils: u' numerator s[m] for m=-3..3 (index shift by +3)
    s = np.array([1.0, -9.0, 45.0, 0.0, -45.0, 9.0, -1.0])  # s[-3],...,s[3]
    # g' numerator weights w(j) for j in {-2,-1,1,2}
    w = { -2: 1.0, -1: -8.0, 1: 8.0, 2: -1.0 }

    rows = []
    cols = []
    data = []
    # RHS initialization: we will store b as already multiplied by 720*h^2
    b = (720.0 * h*h) * f_vals[1:-1].copy()   # len N-1

    # interior convolution helper (returns dict jglob->Ak)
    def interior_Arow(a_vals, i):
        Arow = {}
        # k loops from -5..5
        for k in range(-5, 6):
            Ak = 0.0
            for j in (-2, -1, 1, 2):
                jj = i + j
                m = k - j                         # index for s (must be in [-3..3])
                if -3 <= m <= 3:
                    s_val = s[m + 3]
                    Ak += w[j] * a_vals[jj] * s_val
            if Ak != 0.0:
                Arow[i + k] = Ak
        return Arow

    # Boundary moment-matching builder: build D_j so that
    # (1/(720*h^2)) * sum_j D_j * u(x_j) == (a u')'(x_i) for monomials u=x^p, p=0..4
    def build_boundary_row(i, side):
        if side == 'left':
            jlist = list(range(0, 5))   # u0..u4
        else:
            jlist = list(range(N-4, N+1))  # u_{N-4}..u_N
        m = len(jlist)
        # construct Vandermonde for monomials p=0..4 evaluated at x_j
        M = np.zeros((5, m))
        RHS = np.zeros(5)
        # need a' at xi
        a_prime = compute_a_prime(a_vals, h)
        xi = xs[i]
        for p in range(5):
            for col, jglob in enumerate(jlist):
                M[p, col] = (xs[jglob] ** p)
            # continuous operator applied to x^p:
            # u = x^p => u' = p x^{p-1}, u'' = p(p-1) x^{p-2}
            # (a u')' = a' * u' + a * u''
            uprime = 0.0 if p == 0 else p * (xi ** (p-1))
            u2 = 0.0 if p <= 1 else p * (p-1) * (xi ** (p-2))
            Lp = a_prime[i] * uprime + a_vals[i] * u2
            RHS[p] = 720.0 * h*h * Lp
        # Solve M D = RHS (square 5x5)
        D = np.linalg.solve(M, RHS)
        # return dict jglob->D_j
        return { jlist[k]: float(D[k]) for k in range(len(jlist)) }

    # assemble rows
    for i in range(1, N):
        row = i - 1
        if (i-5 >= 0) and (i+5 <= N):
            Arow = interior_Arow(a_vals, i)
            for jglob, Ak in Arow.items():
                if 1 <= jglob <= N-1:
                    rows.append(row); cols.append(jglob-1); data.append(Ak)
                else:
                    # known boundary
                    if jglob == 0:
                        b[row] -= Ak * alpha
                    elif jglob == N:
                        b[row] -= Ak * beta
        else:
            # boundary closure
            side = 'left' if i <= 5 else 'right'
            Ddict = build_boundary_row(i, side)
            for jglob, Dj in Ddict.items():
                if 1 <= jglob <= N-1:
                    rows.append(row); cols.append(jglob-1); data.append(Dj)
                else:
                    if jglob == 0:
                        b[row] -= Dj * alpha
                    elif jglob == N:
                        b[row] -= Dj * beta

    A = csr_matrix((np.array(data, dtype=float), (np.array(rows,dtype=int), np.array(cols,dtype=int))),
                   shape=(N-1, N-1))
    return A, b, xs

# -----------------------------
# Solve the system iteratively
# -----------------------------
def solve_iterative(A, b, tol=1e-10, method='gmres', verbose=True):
    """Solve A x = b using an iterative solver. Default: gmres + ILU precond."""
    n = A.shape[0]
    # try ILU preconditioner
    try:
        ilu = spilu(A.tocsc(), drop_tol=1e-4, fill_factor=10.0)
        M = LinearOperator(A.shape, matvec=lambda x: ilu.solve(x))
        if verbose: print("ILU preconditioner built.")
    except Exception as e:
        # fallback to Jacobi
        if verbose: print("ILU failed (fallback to Jacobi). Reason:", e)
        D = A.diagonal()
        Dsafe = np.where(np.abs(D) > 1e-16, D, 1.0)
        M = LinearOperator(A.shape, matvec=lambda x: x / Dsafe)

    if method == 'gmres':
        x, info = gmres(A, b, M=M, restart=50)
        if verbose:
            if info == 0: print("GMRES converged.")
            else: print("GMRES info:", info)
        return x, info
    else:
        # fallback direct solve (shouldn't happen normally)
        x = spsolve(A, b)
        return x, None

# -----------------------------
# Convergence / plotting
# -----------------------------
def convergence_plot(a_func, f_func, u_exact_func, alpha, beta, Ns=[40,80,160,320], method='gmres'):
    errors = []
    hs = []
    for N in Ns:
        A, b, xs = assemble_system(a_func, f_func, alpha, beta, N)
        # solve A u_inner = b
        u_inner, info = solve_iterative(A, b, method=method)
        u = np.empty(N+1)
        u[0] = alpha; u[1:-1] = u_inner; u[-1] = beta
        u_ex = u_exact_func(xs)
        err = np.max(np.abs(u - u_ex))
        errors.append(err); hs.append(1.0/N)
        print(f"N={N:5d}, h={1.0/N:.1e}, max-error={err:.3e}")
    hs = np.array(hs); errors = np.array(errors)
    slope, c = np.polyfit(np.log(hs), np.log(errors), 1)
    slope = slope  # slope is approx. order (negative)
    plt.figure(figsize=(6,4))
    plt.loglog(hs, errors, 'o-', label=f'error (slope={slope:.2f})')
    plt.gca().invert_xaxis()
    plt.grid(True, which='both', ls=':')
    plt.xlabel('h'); plt.ylabel('max error')
    plt.title('Convergence (max error) vs h')
    plt.legend()
    plt.show()
    return Ns, hs, errors

# -----------------------------
# Example usage (a=1+x, f=1)
# -----------------------------
if __name__ == "__main__":
    a_fun = lambda x: 1.0 + x
    f_fun = lambda x: np.ones_like(x)
    # exact solution for this specific problem:
    alpha = 0.0; beta = 0.0
    Acoef = (beta - alpha + 1.0) / np.log(2.0)
    def u_exact(x): return Acoef * np.log(1.0 + x) - x + alpha

    Ns, hs, errors = convergence_plot(a_fun, f_fun, u_exact, alpha, beta,
                                      Ns=[40,80,160], method='gmres')