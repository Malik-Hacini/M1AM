# Conservative 4th-order FD with correct 5-point boundary closures (Vandermonde matching)
import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from scipy.sparse.linalg import gmres, spilu, LinearOperator

# ---------------------------
# helper stencils & convolution
# ---------------------------
def _uprime_6coeffs():
    # numerator weights s_{m} for m=-3..3 (for u' numerator)
    # -u_{j+3} + 9 u_{j+2} -45 u_{j+1} + 45 u_{j-1} -9 u_{j-2} + u_{j-3}
    return np.array([1.0, -9.0, 45.0, 0.0, -45.0, 9.0, -1.0])  # s[-3]..s[3]

def _gprime_weights():
    # g' numerator weights w(j) for j in {-2,-1,1,2} matching -g_{i+2} + 8g_{i+1} -8g_{i-1} + g_{i-2}
    return { -2: 1.0, -1: -8.0, 1: 8.0, 2: -1.0 }

# interior convolution: compute numerator entries A_{i, i+k} for k=-5..5
def _interior_row_A(a_vals, i):
    s = _uprime_6coeffs()
    w = _gprime_weights()
    Arow = {}
    for k in range(-5, 6):
        Ak = 0.0
        for j in (-2, -1, 1, 2):
            jj = i + j
            m = k - j  # index into s
            if -3 <= m <= 3:
                Ak += w[j] * a_vals[jj] * s[m + 3]
        if Ak != 0.0:
            Arow[i + k] = Ak
    return Arow

# ---------------------------
# compute local derivative of a (if a_prime not provided)
# ---------------------------
def _local_a_prime(a_vals, xs, jlist, xi):
    """
    Fit polynomial of degree len(jlist)-1 through (x_j, a_j) and return derivative at xi.
    This gives an accurate local derivative consistent with Lagrange/Taylor matching.
    """
    xj = xs[jlist]
    aj = a_vals[jlist]
    deg = min(4, len(jlist)-1)
    # polyfit returns highest->lowest
    p = np.polyfit(xj, aj, deg)
    pd = np.polyder(p)
    return np.polyval(pd, xi)

# ---------------------------
# Build boundary row by Vandermonde matching
# ---------------------------
def _build_boundary_row(a_vals, xs, i, side, h, a_prime_func=None):
    """
    Build D_j numerators for j in jlist (len 5) such that
      (1/(720*h^2)) * sum_j D_j u(x_j) == (a u')'(x_i) for u(x)=x^p, p=0..4.
    Returns dict {jglob: D_j}.
    """
    N = len(xs)-1
    if side == 'left':
        jlist = list(range(0, 5))          # u0..u4
    else:
        jlist = list(range(N-4, N+1))      # u_{N-4}..u_N

    m = len(jlist)   # should be 5
    # build Vandermonde M_{p,j} = x_j^p for p=0..4
    M = np.zeros((5, m), dtype=float)
    RHS = np.zeros(5, dtype=float)
    xi = xs[i]

    # Need a(xi) and a'(xi)
    a_xi = float(np.interp(xi, xs, a_vals))   # exact via interpolation (a_func used outside)
    if a_prime_func is not None:
        a_prime_xi = float(a_prime_func(xi))
    else:
        # compute a' by polynomial fit through jlist nodes
        a_prime_xi = _local_a_prime(a_vals, xs, jlist, xi)

    # Fill M and RHS by testing monomials u(x)=x^p
    for p in range(5):
        for col, jglob in enumerate(jlist):
            M[p, col] = xs[jglob]**p
        # continuous operator applied to u = x^p:
        # u' = p x^{p-1}, u'' = p(p-1) x^{p-2}
        uprime = 0.0 if p == 0 else p * (xi ** (p-1))
        u2 = 0.0 if p <= 1 else p*(p-1) * (xi ** (p-2))
        Lp = a_prime_xi * uprime + a_xi * u2
        RHS[p] = 720.0 * h*h * Lp     # right-hand side in numerator scaling
    # Solve for D_j
    D = np.linalg.solve(M, RHS)
    return { jlist[k]: float(D[k]) for k in range(m) }

# ---------------------------
# Main assembler
# ---------------------------
def assemble_A_b_correct(a_func, f_func, alpha, beta, N, a_prime_func=None):
    """
    Assemble numerator matrix A (so that (1/(720 h^2)) A u_inner = f_inner),
    and RHS b already scaled as 720*h^2 * f_inner with Dirichlet contributions moved to b.
    Returns (A_csr, b, xs).
    """
    h = 1.0 / N
    xs = np.linspace(0.0, 1.0, N+1)
    a_vals = a_func(xs)
    f_vals = f_func(xs)

    rows = []; cols = []; data = []
    b = (720.0 * h*h) * f_vals[1:-1].copy()   # length N-1

    for i in range(1, N):
        row = i - 1
        # interior usable if i-5 >=0 and i+5 <= N
        if (i-5 >= 0) and (i+5 <= N):
            Arow = _interior_row_A(a_vals, i)
            for jglob, Ak in Arow.items():
                if 1 <= jglob <= N-1:
                    rows.append(row); cols.append(jglob-1); data.append(Ak)
                else:
                    if jglob == 0:
                        b[row] -= Ak * alpha
                    elif jglob == N:
                        b[row] -= Ak * beta
        else:
            side = 'left' if i <= 4 else 'right'
            Ddict = _build_boundary_row(a_vals, xs, i, side, h, a_prime_func=a_prime_func)
            for jglob, Dj in Ddict.items():
                if 1 <= jglob <= N-1:
                    rows.append(row); cols.append(jglob-1); data.append(Dj)
                else:
                    if jglob == 0:
                        b[row] -= Dj * alpha
                    elif jglob == N:
                        b[row] -= Dj * beta

    A = csr_matrix((np.array(data,dtype=float), (np.array(rows,dtype=int), np.array(cols,dtype=int))),
                   shape=(N-1, N-1))
    return A, b, xs

# ---------------------------
# iterative solver (GMRES + ILU fallback to Jacobi)
# ---------------------------
def solve_gmres_ilu(A, b, tol=1e-10):
    try:
        ilu = spilu(A.tocsc(), drop_tol=1e-4, fill_factor=10.0)
        M = LinearOperator(A.shape, matvec=lambda x: ilu.solve(x))
        x, info = gmres(A, b, M=M, restart=50)
    except Exception as e:
        # fallback Jacobi
        D = A.diagonal()
        Dsafe = np.where(np.abs(D) > 1e-16, D, 1.0)
        M = LinearOperator(A.shape, matvec=lambda x: x / Dsafe)
        x, info = gmres(A, b, M=M, restart=50)
    return x, info

# ---------------------------
# convergence test & plot
# ---------------------------
def convergence_test(a_func, f_func, u_exact, alpha, beta, Ns=[40,80,160,320], a_prime_func=None):
    hs = []; errs = []
    for N in Ns:
        A, b, xs = assemble_A_b_correct(a_func, f_func, alpha, beta, N, a_prime_func=a_prime_func)
        u_inner, info = solve_gmres_ilu(A, b)
        u = np.empty(N+1); u[0]=alpha; u[1:-1]=u_inner; u[-1]=beta
        e = np.max(np.abs(u - u_exact(xs)))
        hs.append(1.0/N); errs.append(e)
        print(f"N={N:5d}  h={1.0/N:.2e}  max-error={e:.3e}  gmres-info={info}")
    hs = np.array(hs); errs = np.array(errs)
    slope, intercept = np.polyfit(np.log(hs), np.log(errs), 1)
    print(f"fitted slope (order) ≈ {slope:.2f}")
    plt.figure(figsize=(6,4))
    plt.loglog(hs, errs, 'o-', label=f'error (slope~{slope:.2f})')
    plt.gca().invert_xaxis()
    plt.xlabel('h'); plt.ylabel('max error'); plt.grid(True, which='both', ls=':')
    plt.legend()
    plt.show()
    return Ns, hs, errs

# ---------------------------
# Usage example (a(x)=1+x, f=1) - define exact u for testing
# ---------------------------
if __name__ == "__main__":
    a_fun = lambda x: 1.0 + x
    f_fun = lambda x: np.ones_like(x)
    alpha = 0.0; beta = 0.0
    Acoef = (beta - alpha + 1.0) / np.log(2.0)
    u_exact = lambda x: Acoef * np.log(1.0 + x) - x + alpha

    Ns, hs, errs = convergence_test(a_fun, f_fun, u_exact, alpha, beta,
                                    Ns=[40, 80, 160, 320], a_prime_func=None)
