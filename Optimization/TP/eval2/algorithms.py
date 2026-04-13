import numpy as np
import timeit
from scipy.optimize import minimize, line_search


def BFGS(f, grad_f, x_init):
    res = minimize(f, x_init, method='BFGS', jac=grad_f, options={'disp': True})
    return res.x


def GD(f, grad_f, x_init, tau, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("GD with constant step size")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(x)
        x = x - tau*g

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def GD_backtracking(f, grad_f, x_init, tau0, rho, c, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("GD with backtracking line search")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(x)
        tau = tau0
        while f(x - tau*g) > f(x) - c*tau*np.linalg.norm(g)**2:
            tau = rho*tau

        x = x - tau*g
        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def GD_exact(A, f, grad_f, x_init, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("GD with exact line search")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(x)
        tau = np.inner(g,g)/np.inner(g,A@g)
        x = x - tau*g
        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def GD_wolfe(f , f_grad , x_init , prec, iterMax):

    x = np.copy(x_init)
    epsilon = prec*np.linalg.norm(f_grad(x_init) )
    x_tab = np.copy(x)

    print("Gradient with Wolfe line search")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g = f_grad(x)

        res = line_search(f, f_grad, x, -g, gfk=None, old_fval=None, old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0] if res[0] is not None else 1.0

        x = x - tau*g

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(f_grad(x))))

    return x,x_tab


def newton(f , f_grad_hessian , x_init , prec , iterMax ):
    x = np.copy(x_init)
    g,H = f_grad_hessian(x_init)
    epsilon = prec*np.linalg.norm(g)

    x_tab = np.copy(x)
    print("Newton's algorithm")
    t_s = timeit.default_timer()
    for k in range(iterMax):

        g,H = f_grad_hessian(x)
        x = x - np.linalg.solve(H,g)

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(g)))
    return x,x_tab


def bfgs(f , f_grad , x_init , prec , iterMax ):

    x = np.copy(x_init)
    g = f_grad(x_init)
    epsilon = prec*np.linalg.norm(g)

    I = np.eye(len(x))
    W = np.copy(I)

    x_tab = np.copy(x)
    print("BFGS algorithm")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        d = W@g

        res = line_search(f, f_grad, x, -d, gfk=None, old_fval=None, old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0] if res[0] is not None else 1.0

        x_new = x - tau*d
        g_new = f_grad(x_new)

        s = x_new - x
        y = g_new - g
        ys = np.inner(y,s)
        if ys > 0:
            P = I - np.outer(s,y)/ys
            W = P@W@P.T + np.outer(s,s)/ys

        x = x_new
        g = g_new

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(g)))
    return x,x_tab


def newton_wolfe(f , f_grad_hessian , x_init , prec , iterMax ):
    x = np.copy(x_init)
    g,H = f_grad_hessian(x_init)
    epsilon = prec*np.linalg.norm(g)

    def f_grad(x):
        return f_grad_hessian(x)[0]

    x_tab = np.copy(x)
    print("Newton's algorithm with Wolfe line search")
    t_s = timeit.default_timer()
    for k in range(iterMax):

        g,H = f_grad_hessian(x)
        try:
            d = np.linalg.solve(H,g)
        except np.linalg.LinAlgError:
            d = np.linalg.pinv(H)@g
        res = line_search(f, f_grad, x, -d, gfk=g, old_fval=f(x), old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0] if res[0] is not None else 1.0
        x = x - tau*d

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(f_grad(x))))
    return x,x_tab


def GD_accelerated(f, grad_f, x_init, tau, iterMax, prec, c=0.5):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    y = np.copy(x_init)
    lmbd = 0.0

    print("Accelerated GD with constant step size")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(y)
        x_new = y - tau*g
        lmbd_new = 0.5*(1 + np.sqrt(1 + 4*lmbd**2))
        y = x_new + ((lmbd - 1)/lmbd_new)*(x_new - x)
        x = x_new
        lmbd = lmbd_new

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def CG_quadratic(A, b, f, grad_f, x_init, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    r = -(A@x + b)
    d = r

    print("CG for quadratic objective")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        alpha = np.inner(r,r)/np.inner(d,A@d)
        x = x + alpha*d
        r_new = r - alpha*(A@d)
        x_tab = np.vstack((x_tab,x))
        beta = np.inner(r_new,r_new)/np.inner(r,r)
        d = r_new + beta*d
        r = r_new

        if np.linalg.norm(grad_f(x)) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def CG_nonLinear(f, grad_f, x_init, iterMax, prec, tau0, rho, c):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    r = -grad_f(x)
    d = r

    print("CG for quadratic objective")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(x)
        tau = tau0
        while f(x + tau*d) > f(x) + c*tau*np.inner(g,d):
            tau = rho*tau
        x = x + tau*d
        r_new = -grad_f(x)
        x_tab = np.vstack((x_tab,x))
        beta = max(np.inner(r_new,r_new - r)/np.inner(r,r),0.0)
        d = r_new + beta*d
        r = r_new

        if np.linalg.norm(grad_f(x)) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def SGD(f, grad_f_subsampling, x_init, tau0, schedule, iterMax):

    x = np.copy(x_init)
    x_tab = np.copy(x)
    tau = np.copy(tau0)

    x_avg = np.copy(x)
    x_avg_tab = np.copy(x_avg)
    x_sum = np.zeros(len(x_init))
    tau_sum = 0.0

    print("Stochastic gradient descent")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        if schedule == "decreasing":
            tau = 1 / (k+1)

        g = grad_f_subsampling(x)
        x_new = x - tau*g

        x_tab = np.vstack((x_tab,x_new))

        x_sum = x_sum + tau*x
        tau_sum = tau_sum + tau
        x_avg = (1 / tau_sum)*x_sum
        x_avg_tab = np.vstack((x_avg_tab,x_avg))

        x = x_new

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x_avg)))

    return x,x_tab,x_avg, x_avg_tab


def adagrad_norm(f, grad_f_subsampling, x_init, tau, b_sq, iterMax):

    x = np.copy(x_init)
    x_tab = np.copy(x)

    G = np.copy(b_sq)

    print("Adagrad-norm")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f_subsampling(x)
        G = G + np.linalg.norm(g)**2
        x = x - tau*g/np.sqrt(G)

        x_tab = np.vstack((x_tab,x))

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))

    return x,x_tab


def adagrad_diag(f, grad_f_subsampling, x_init, tau, b_sq, iterMax):

    x = np.copy(x_init)
    x_tab = np.copy(x)

    G = b_sq*np.ones(len(x_init))

    print("Adagrad")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f_subsampling(x)
        G = G + g**2
        x = x - tau*g/np.sqrt(G)

        x_tab = np.vstack((x_tab,x))

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))

    return x,x_tab


def adam(f, grad_f_subsampling, x_init, tau, beta1, beta2, delta, iterMax):

    x = np.copy(x_init)
    x_tab = np.copy(x)

    m = np.zeros(len(x_init))
    v = np.zeros(len(x_init))

    print("Adam")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        g = grad_f_subsampling(x)
        m = beta1*m + (1-beta1)*g
        v = beta2*v + (1-beta2)*(g**2)
        m_hat = m/(1-beta1**(k+1))
        v_hat = v/(1-beta2**(k+1))
        x = x - tau*m_hat/np.sqrt(delta + v_hat)

        x_tab = np.vstack((x_tab,x))

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))

    return x,x_tab


def proj_GD(f, grad_f, proj, x_init, tau, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("Projected GD")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        x_new = proj(x - tau*grad_f(x))
        step = np.linalg.norm(x_new - x)
        x = x_new

        x_tab = np.vstack((x_tab,x))

        if step < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))

    return x,x_tab


def POCS(proj, x_init, iterMax):
    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("POCS")
    t_s = timeit.default_timer()

    for k in range(iterMax):

        x = proj(x)

        x_tab = np.vstack((x_tab,x))

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s \n\n".format(k,t_e-t_s))

    return x,x_tab


def prox_grad(F, grad_f, prox_g, x_init, tau, iterMax, prec):
    x = np.copy(x_init)
    x_tab = np.copy(x)
    epsilon = prec

    print("Proximal gradient")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        x_new = prox_g(x - tau*grad_f(x), tau)
        x_tab = np.vstack((x_tab, x_new))
        if np.linalg.norm(x_new - x) < epsilon:
            x = x_new
            break
        x = x_new

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k, t_e - t_s, F(x)))

    return x, x_tab


__all__ = [
    "BFGS",
    "GD",
    "GD_backtracking",
    "GD_exact",
    "GD_wolfe",
    "newton",
    "bfgs",
    "newton_wolfe",
    "GD_accelerated",
    "CG_quadratic",
    "CG_nonLinear",
    "SGD",
    "adagrad_norm",
    "adagrad_diag",
    "adam",
    "proj_GD",
    "POCS",
    "prox_grad",
]
