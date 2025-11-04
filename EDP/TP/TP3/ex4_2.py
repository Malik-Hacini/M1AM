import numpy as np
import matplotlib
matplotlib.use('Qt5Agg')
import matplotlib.pyplot as plt

from scipy.sparse import csr_matrix
from scipy.sparse.linalg import spsolve

# ----------------------------
# assembler (same as before)
# ----------------------------
def _estimate_a_prime(xs, a_vals):
    N = len(xs)-1
    h = xs[1]-xs[0]
    ap = np.zeros_like(a_vals)
    # interior 4th-order central for i=2..N-2
    for i in range(2, N-1):
        ap[i] = (-a_vals[i+2] + 8*a_vals[i+1] - 8*a_vals[i-1] + a_vals[i-2]) / (12.0*h)
    # fallback near boundaries (4th-order one-sided estimates)
    # leftmost:
    ap[0] = (-25*a_vals[0] + 48*a_vals[1] - 36*a_vals[2] + 16*a_vals[3] - 3*a_vals[4])/(12.0*h)
    ap[1] = (a_vals[2] - a_vals[0])/(2.0*h)
    # rightmost:
    ap[N-1] = (a_vals[N-1] - a_vals[N-3])/(2.0*h)
    ap[N]   = ( 25*a_vals[N] - 48*a_vals[N-1] + 36*a_vals[N-2] -16*a_vals[N-3] + 3*a_vals[N-4])/(12.0*h)
    return ap

def build_A_b(N, a_func, f_func, alpha, beta, a_prime_func=None):
    """
    Assemble A and b such that (1/h^2) * A * u_inner = f_inner,
    i.e. A * u_inner = h^2 * f_inner - boundary contributions.
    Returns A (csr_matrix), b (numpy array), xs (grid).
    """
    h = 1.0 / N
    xs = np.linspace(0.0, 1.0, N+1)
    a_vals = a_func(xs)
    f_vals = f_func(xs)

    if a_prime_func is not None:
        a_prime_vals = a_prime_func(xs)
    else:
        a_prime_vals = _estimate_a_prime(xs, a_vals)

    rows = []
    cols = []
    data = []
    b = (h*h) * f_vals[1:-1].copy()   # length N-1

    def add_entry(i_row, j_global, val):
        # i_row in 0..N-2 ; j_global in 0..N ; val already scaled by h^2 (numerator/12)
        if 1 <= j_global <= N-1:
            rows.append(i_row)
            cols.append(j_global-1)
            data.append(val)
        else:
            if j_global == 0:
                b[i_row] -= val * alpha
            elif j_global == N:
                b[i_row] -= val * beta
            else:
                raise IndexError("Unexpected column index while assembling.")

    for i in range(1, N):
        row = i - 1
        a_i = a_vals[i]
        ap_i = a_prime_vals[i]

        if i == 1:
            # one-sided left (coefficients scaled by h^2 => numerator/12)
            w0 = (-11.0*a_i + 3.0*ap_i*h) / 12.0
            w1 = (5.0*(2.0*a_i + ap_i*h)) / 6.0
            w2 = (-a_i - 3.0*ap_i*h) / 2.0
            w3 = (-2.0*a_i + 3.0*ap_i*h) / 6.0
            w4 = (a_i - ap_i*h) / 12.0
            add_entry(row, 0, w0)
            add_entry(row, 1, w1)
            add_entry(row, 2, w2)
            add_entry(row, 3, w3)
            add_entry(row, 4, w4)
        elif i == N-1:
            # one-sided right
            w_nm4 = (a_i + ap_i*h) / 12.0
            w_nm3 = (-2.0*a_i - 3.0*ap_i*h) / 6.0
            w_nm2 = (-a_i + 3.0*ap_i*h) / 2.0
            w_nm1 = (5.0*(2.0*a_i - ap_i*h)) / 6.0
            w_n   = (-11.0*a_i - 3.0*ap_i*h) / 12.0
            add_entry(row, N-4, w_nm4)
            add_entry(row, N-3, w_nm3)
            add_entry(row, N-2, w_nm2)
            add_entry(row, N-1, w_nm1)
            add_entry(row, N,   w_n)
        else:
            # interior: offsets -2..+2, scaled by h^2 (numerator/12)
            w_p2 = (a_i + ap_i*h) / 12.0
            w_p1 = (-16.0*a_i - 8.0*ap_i*h) / 12.0
            w_0  = (30.0*a_i) / 12.0
            w_m1 = (-16.0*a_i + 8.0*ap_i*h) / 12.0
            w_m2 = (a_i - ap_i*h) / 12.0
            add_entry(row, i+2, w_p2)
            add_entry(row, i+1, w_p1)
            add_entry(row, i  , w_0)
            add_entry(row, i-1, w_m1)
            add_entry(row, i-2, w_m2)

    A = csr_matrix((np.array(data, dtype=float), (np.array(rows,dtype=int), np.array(cols,dtype=int))),
                   shape=(N-1, N-1))
    return A, b, xs

# ----------------------------
# convergence plotting routine
# ----------------------------
def plot_convergence(a_func, f_func, u_exact_func, alpha, beta,
                     a_prime_func=None, Ns=None, solver='direct',
                     show_plot=True, figsize=(6,4)):
    """
    Compute max-norm errors for a list of N values and plot error vs h on log-log.
    Returns (Ns, hs, errors).
      - a_func(x), f_func(x): callables vectorized on numpy arrays
      - u_exact_func(x): exact solution callable (vectorized)
      - alpha, beta: Dirichlet values
      - a_prime_func: optional a'(x) callable
      - Ns: list of N (number of intervals). If None uses [20,40,80,160,320]
      - solver: 'direct' uses spsolve; for large N you may replace with iterative
    """
    if Ns is None:
        Ns = [20, 40, 80, 160, 320]

    errors = []
    hs = []
    for N in Ns:
        A, b, xs = build_A_b(N, a_func, f_func, alpha, beta, a_prime_func=a_prime_func)
        # solve A u_inner = b
        if solver == 'direct':
            u_inner = spsolve(A, b)
        else:
            # fallback to direct for now; you can add iterative solvers if desired
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

    # estimate order via linear fit in log-log: log(error) ~ p*log(h) + C
    p, logC = np.polyfit(np.log(hs), np.log(errors), 1)
    order_est = -p  # because error ~ C*h^{order} and slope is p = order (with negative log(h))
    # careful sign: since log(error) = slope*log(h)+..., slope should be ~ order
    # but we want positive order; reorder correctly:
    slope = p
    estimated_order = slope

    # Plot
    if show_plot:
        plt.figure(figsize=figsize)
        plt.loglog(hs, errors, 'o-', label='max error')
        # plot reference line with slope estimated
        # pick C so that ref line passes through last point
        C = np.exp(logC)
        ref_line = C * hs**p
        plt.loglog(hs, ref_line, '--', label=f'fit: slope={p:.2f}')
        plt.gca().invert_xaxis()  # often nicer to have N increasing to the right
        plt.xlabel('h')
        plt.ylabel('max error (L^infty)')
        plt.title('Convergence (max error) vs h')
        plt.grid(True, which='both', ls=':')
        plt.legend()
        plt.annotate(f"estimated slope = {p:.2f}", xy=(0.03, 0.03), xycoords='figure fraction')
        plt.show()

    return Ns, hs, errors

# ----------------------------
# Example: a(x)=1+x, f=1, exact solution (alpha,beta) general
# exact solution derived: u(x) = A ln(1+x) - x + alpha, A = (beta - alpha + 1)/ln 2
# ----------------------------
def example_run():
    a_func = lambda x: 1.0 + x
    f_func = lambda x: np.ones_like(x)
    a_prime = lambda x: np.ones_like(x)
    alpha = 0.0
    beta = 0.0
    Acoef = (beta - alpha + 1.0) / np.log(2.0)
    def u_exact(x):
        return Acoef * np.log(1.0 + x) - x + alpha

    Ns, hs, errors = plot_convergence(a_func, f_func, u_exact, alpha, beta,
                                      a_prime_func=a_prime, Ns=[20,40,80,160,320])
    return Ns, hs, errors

# If run as script, run example:
if __name__ == "__main__":
    example_run()
