import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from scipy.sparse.linalg import gmres, spilu, LinearOperator, spsolve

# ---------------------------
# utilities
# ---------------------------
def compute_a_prime_4th(a_vals, h):
    """4th-order derivative estimate of a at nodes using 5-point stencils."""
    N = len(a_vals) - 1
    ap = np.zeros_like(a_vals)
    # interior central 4th-order
    for i in range(2, N-1):
        ap[i] = (-a_vals[i+2] + 8*a_vals[i+1] - 8*a_vals[i-1] + a_vals[i-2]) / (12.0*h)
    # one-sided 4th-order near left
    ap[0] = (-25*a_vals[0] + 48*a_vals[1] - 36*a_vals[2] + 16*a_vals[3] - 3*a_vals[4])/(12.0*h)
    ap[1] = (-3*a_vals[0] - 10*a_vals[1] + 18*a_vals[2] - 6*a_vals[3] + a_vals[4])/(12.0*h)
    # one-sided 4th-order near right
    ap[N-1] = (3*a_vals[N] + 10*a_vals[N-1] - 18*a_vals[N-2] + 6*a_vals[N-3] - a_vals[N-4])/(12.0*h)
    ap[N]   = (25*a_vals[N] - 48*a_vals[N-1] + 36*a_vals[N-2] - 16*a_vals[N-3] + 3*a_vals[N-4])/(12.0*h)
    return ap

# ---------------------------
# core assembler with correct 5-point boundary closures
# ---------------------------
def assemble_system_fixed(a_func, f_func, alpha, beta, N):
    """
    Assemble A, b, xs so that (1/(720*h^2)) * A * u_inner = f_inner,
    with correct 4th-order one-sided boundary closures using exactly 5 points.
    Returns: A (csr), b (length N-1), xs (grid)
    """
    h = 1.0 / N
    xs = np.linspace(0.0, 1.0, N+1)
    a_vals = a_func(xs)
    f_vals = f_func(xs)

    # stencils
    s = np.array([1.0, -9.0, 45.0, 0.0, -45.0, 9.0, -1.0])  # u' numerator s[-3..3]
    w = { -2: 1.0, -1: -8.0, 1: 8.0, 2: -1.0 }             # g' numerator weights

    rows = []; cols = []; data = []
    b = (720.0 * h*h) * f_vals[1:-1].copy()   # RHS stored with numerator scaling

    def interior_Arow(a_vals, i):
        """Build interior numerator Arow mapping jglob->Ak for i where full stencil exists."""
        Arow = {}
        for k in range(-5, 6):
            Ak = 0.0
            for j in (-2, -1, 1, 2):
                jj = i + j
                m = k - j
                if -3 <= m <= 3:
                    Ak += w[j] * a_vals[jj] * s[m + 3]
            if Ak != 0.0:
                Arow[i+k] = Ak
        return Arow

    # precompute a' with 4th-order accuracy
    a_prime = compute_a_prime_4th(a_vals, h)

    def build_boundary_row(i, side):
        """
        Build one-sided closure for node i using exactly 5 points on that side
        (jlist length 5) and return dict {jglob: D_j} where D_j are numerators
        so that (1/(720*h^2)) * sum_j D_j u_j approximates (a u')'(x_i) to O(h^4).
        """
        if side == 'left':
            jlist = list(range(0, 5))   # u0..u4
        else:
            jlist = list(range(N-4, N+1))  # u_{N-4}..u_N

        m = len(jlist)
        # build Vandermonde for p=0..4
        M = np.zeros((5, m))
        RHS = np.zeros(5)
        xi = xs[i]
        for p in range(5):
            for col, jglob in enumerate(jlist):
                M[p, col] = xs[jglob]**p
            # Continuous operator for u=x^p:
            # u' = p x^{p-1}, u'' = p(p-1) x^{p-2}
            uprime = 0.0 if p == 0 else p * xi**(p-1)
            u2 = 0.0 if p <= 1 else p*(p-1) * xi**(p-2)
            Lp = a_prime[i]*uprime + a_vals[i]*u2
            RHS[p] = 720.0 * h*h * Lp
        # Solve for D (should be square 5x5)
        D = np.linalg.solve(M, RHS)
        return { jlist[k]: float(D[k]) for k in range(m) }

    # assemble all rows i=1..N-1
    for i in range(1, N):
        row = i - 1
        if (i-5 >= 0) and (i+5 <= N):
            Arow = interior_Arow(a_vals, i)
            for jglob, Ak in Arow.items():
                if 1 <= jglob <= N-1:
                    rows.append(row); cols.append(jglob-1); data.append(Ak)
                else:
                    if jglob == 0:
                        b[row] -= Ak * alpha
                    elif jglob == N:
                        b[row] -= Ak * beta
        else:
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

# ---------------------------
# iterative solver (GMRES + ILU)
# ---------------------------
def solve_iterative(A, b, tol=1e-10):
    try:
        ilu = spilu(A.tocsc(), drop_tol=1e-4, fill_factor=10.0)
        M = LinearOperator(A.shape, matvec=lambda x: ilu.solve(x))
        x, info = gmres(A, b, M=M, restart=50)
    except Exception as e:
        # fallback Jacobi preconditioner
        D = A.diagonal()
        Dsafe = np.where(np.abs(D)>1e-16, D, 1.0)
        M = LinearOperator(A.shape, matvec=lambda x: x / Dsafe)
        x, info = gmres(A, b, M=M, tol=tol, restart=50)
    return x, info

# ---------------------------
# convergence tester (plot)
# ---------------------------
def convergence_plot(a_func, f_func, u_exact, alpha, beta, Ns=[40,80,160,320]):
    hs = []; errors = []
    for N in Ns:
        A, b, xs = assemble_system_fixed(a_func, f_func, alpha, beta, N)
        u_inner, info = solve_iterative(A, b)
        u = np.empty(N+1); u[0]=alpha; u[1:-1]=u_inner; u[-1]=beta
        err = np.max(np.abs(u - u_exact(xs)))
        hs.append(1.0/N); errors.append(err)
        print(f"N={N}, max-error={err:.3e}, gmres-info={info}")
    hs = np.array(hs); errors = np.array(errors)
    slope, intercept = np.polyfit(np.log(hs), np.log(errors), 1)
    slope = slope  # slope ≈ order
    plt.figure(figsize=(6,4))
    plt.loglog(hs, errors, 'o-', label=f'order ≈ {slope:.2f}')
    plt.gca().invert_xaxis()
    plt.xlabel('h'); plt.ylabel('max error'); plt.grid(True,which='both'); plt.legend()
    plt.show()
    return Ns, hs, errors

# ---------------------------
# example (for testing locally)
# ---------------------------
if __name__ == "__main__":
    a_fun = lambda x: 1.0 + x
    f_fun = lambda x: np.ones_like(x)
    alpha = 0.0; beta = 0.0
    Acoef = (beta - alpha + 1.0) / np.log(2.0)
    u_exact = lambda x: Acoef * np.log(1.0 + x) - x + alpha
    Ns, hs, errors = convergence_plot(a_fun, f_fun, u_exact, alpha, beta, Ns=[40,80,160])
