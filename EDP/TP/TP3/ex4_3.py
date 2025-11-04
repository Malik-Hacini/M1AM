import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from scipy.sparse.linalg import spsolve

# -------------------------
# Flux-based assembler
# -------------------------
def build_A_b_flux(N, a_func, f_func, alpha, beta):
    """
    Assemble A and b for the 4th-order flux-conservative discretization:
        (1/h^2) * A * u_inner = f_inner,
    where u_inner = [u1..u_{N-1}] (Dirichlet u0=alpha, uN=beta).
    Returns (A (csr), b (numpy array), xs (grid points)).
    """
    h = 1.0 / N
    xs = np.linspace(0.0, 1.0, N+1)
    x_mid = xs[:-1] + 0.5*h           # midpoints x_{i+1/2}, length N
    a_half = a_func(x_mid)            # a evaluated at midpoints
    f_vals = f_func(xs)

    # Predefine fractional coefficients (as floats) used in boundary rows
    # LEFT boundary (i=1) pairs: coefficients for (a_{3/2}, a_{1/2}) respectively:
    left_pairs = [
        (-1.0/24.0, -11.0/12.0),   # A_{1,0}  (u0)
        ( 9.0/8.0,   17.0/24.0),   # A_{1,1}
        (-9.0/8.0,   3.0/8.0),     # A_{1,2}
        ( 1.0/24.0, -5.0/24.0),    # A_{1,3}
        ( 0.0,       1.0/24.0)     # A_{1,4}
    ]
    # RIGHT boundary pairs (coeff for a_{N-1/2}, a_{N-3/2}) for u_{N-4}..u_N:
    right_pairs = [
        ( 1.0/24.0,  1.0/24.0),     # A_{N-1,N-4}
        (-5.0/24.0, -9.0/8.0),      # A_{N-1,N-3}
        ( 3.0/8.0,   9.0/8.0),      # A_{N-1,N-2}
        ( 17.0/24.0, -1.0/24.0),    # A_{N-1,N-1}
        (-11.0/12.0, 0.0)           # A_{N-1,N}
    ]

    rows = []
    cols = []
    data = []

    # RHS: initialize to h^2 * f_i for interior nodes i=1..N-1
    b = (h*h) * f_vals[1:-1].copy()   # length N-1

    def add_entry(row_idx, j_global, val):
        """Add entry A[row_idx, j_global] = val if j_global in unknowns,
           otherwise move val*u_boundary to RHS (u_0 or u_N)."""
        if 1 <= j_global <= N-1:
            rows.append(row_idx)
            cols.append(j_global - 1)
            data.append(val)
        else:
            if j_global == 0:
                b[row_idx] -= val * alpha
            elif j_global == N:
                b[row_idx] -= val * beta
            else:
                raise IndexError("Unexpected global index in add_entry")

    # Assemble rows i = 1 .. N-1 (matrix row index = i-1)
    for i in range(1, N):
        row = i - 1
        if i == 1:
            # left boundary row uses left_pairs with a_{1/2}=a_half[0], a_{3/2}=a_half[1]
            a1 = a_half[0]
            a3 = a_half[1]
            # local j = 0..4 -> global j = 0..4
            for j_local in range(5):
                coef_a3, coef_a1 = left_pairs[j_local]
                val = coef_a3 * a3 + coef_a1 * a1
                add_entry(row, j_local, val)
        elif i == N-1:
            # right boundary row uses right_pairs with a_{N-1/2}=a_half[N-1], a_{N-3/2}=a_half[N-2]
            ar = a_half[N-1]
            al = a_half[N-2]
            for j_local in range(5):
                # global index = N-4 + j_local
                jglob = N-4 + j_local
                coef_ar, coef_al = right_pairs[j_local]
                val = coef_ar * ar + coef_al * al
                add_entry(row, jglob, val)
        else:
            # interior row i = 2..N-2
            a_iphalf = a_half[i]     # a_{i+1/2}
            a_iminushalf = a_half[i-1]  # a_{i-1/2}
            # use FLUX-4 entries (note these are already the A entries in (1/h^2) A u = f)
            w_m2 = a_iminushalf / 24.0
            w_m1 = -(a_iphalf + 27.0*a_iminushalf) / 24.0
            w_0  =  (27.0*(a_iphalf + a_iminushalf)) / 24.0
            w_p1 = -(27.0*a_iphalf + a_iminushalf) / 24.0
            w_p2 =  a_iphalf / 24.0
            add_entry(row, i-2, w_m2)
            add_entry(row, i-1, w_m1)
            add_entry(row, i  , w_0)
            add_entry(row, i+1, w_p1)
            add_entry(row, i+2, w_p2)

    A = csr_matrix((np.array(data, dtype=float), (np.array(rows, dtype=int), np.array(cols, dtype=int))),
                   shape=(N-1, N-1))
    return A, b, xs

# -------------------------
# Convergence plot (flux)
# -------------------------
def plot_convergence_flux(a_func, f_func, u_exact_func, alpha, beta,
                          Ns=None, show_plot=True):
    """
    Run a convergence sequence for the flux-based scheme and plot max-error vs h.
    Returns Ns, hs, errors arrays.
    """
    if Ns is None:
        Ns = [20, 40, 80, 160, 320]

    errors = []
    hs = []
    for N in Ns:
        A, b, xs = build_A_b_flux(N, a_func, f_func, alpha, beta)
        # solve A u_inner = b
        u_inner = spsolve(A, b)
        u_num = np.empty(N+1)
        u_num[0] = alpha
        u_num[1:-1] = u_inner
        u_num[-1] = beta
        u_ex = u_exact_func(xs)
        err = np.max(np.abs(u_num - u_ex))
        errors.append(err)
        hs.append(1.0 / N)
        print(f"N={N:5d}, h={1.0/N:.3e}, max-error={err:.3e}")

    hs = np.array(hs)
    errors = np.array(errors)

    # linear fit in log-log (global)
    p, logC = np.polyfit(np.log(hs), np.log(errors), 1)
    # p is slope; for expected error ~ C * h^r, slope should be r
    if show_plot:
        plt.figure(figsize=(6,4))
        plt.loglog(hs, errors, 'o-', label='max error')
        plt.loglog(hs, np.exp(logC) * hs**p, '--', label=f'fit slope={p:.2f}')
        plt.gca().invert_xaxis()
        plt.xlabel('h')
        plt.ylabel('max error (L^\infty)')
        plt.title('Flux-based scheme convergence')
        plt.grid(True, which='both', ls=':')
        plt.legend()
        plt.annotate(f"estimated slope = {p:.2f}", xy=(0.05,0.05), xycoords='figure fraction')
        plt.show()

    return Ns, hs, errors

# -------------------------
# Example: test with a(x)=1+x, f=1 and exact solution
# -------------------------
if __name__ == "__main__":
    a_fun = lambda x: 1.0 + x
    f_fun = lambda x: np.ones_like(x)
    # exact solution for this problem: u(x) = A*ln(1+x) - x + alpha, A = (beta - alpha + 1)/ln 2
    alpha = 0.0
    beta  = 0.0
    Acoef = (beta - alpha + 1.0) / np.log(2.0)
    u_exact = lambda x: Acoef * np.log(1.0 + x) - x + alpha

    Ns, hs, errors = plot_convergence_flux(a_fun, f_fun, u_exact, alpha, beta,
                                          Ns=[20,40,80,160,320])
