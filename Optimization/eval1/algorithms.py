import numpy as np
import timeit
from scipy.optimize import line_search


def GD(f, f_grad, x_init, tau, iterMax, prec):
    epsilon = prec * np.linalg.norm(f_grad(x_init))
    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("------------------------------------\n GD with constant step size\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g = f_grad(x)
        x = x - tau * g
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(f_grad(x))))
    return x, x_tab


def GD_wolfe(f, f_grad, x_init, prec, iterMax):
    x = np.copy(x_init)
    epsilon = prec * np.linalg.norm(f_grad(x_init))
    x_tab = np.copy(x)

    print("------------------------------------\n Gradient with Wolfe line search\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g = f_grad(x)
        res = line_search(f, f_grad, x, -g, gfk=None, old_fval=None, old_old_fval=None,
                          args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0]
        if tau is None:
            tau = 1e-4
        x = x - tau * g
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(f_grad(x))))
    return x, x_tab


def newton(f, f_grad_hessian, x_init, prec, iterMax):
    x = np.copy(x_init)
    g, H = f_grad_hessian(x_init)
    epsilon = prec * np.linalg.norm(g)
    x_tab = np.copy(x)

    print("------------------------------------\nNewton's algorithm\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g, H = f_grad_hessian(x)
        x = x - np.linalg.solve(H, g)
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(g)))
    return x, x_tab


def bfgs(f, f_grad, x_init, prec, iterMax):
    x = np.copy(x_init)
    g = f_grad(x_init)
    epsilon = prec * np.linalg.norm(g)
    I = np.eye(len(x))
    W = np.copy(I)
    x_tab = np.copy(x)

    print("------------------------------------\nBFGS algorithm\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        d = W @ g
        res = line_search(f, f_grad, x, -d, gfk=None, old_fval=None, old_old_fval=None,
                          args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0]
        if tau is None:
            tau = 1e-4
        x_new = x - tau * d
        g_new = f_grad(x_new)

        s = x_new - x
        y = g_new - g
        rho = y @ s
        if rho > 1e-10:
            rho = 1.0 / rho
            W = (I - rho * np.outer(s, y)) @ W @ (I - rho * np.outer(y, s)) + rho * np.outer(s, s)

        x = x_new
        g = g_new
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(g)))
    return x, x_tab


def newton_wolfe(f, f_grad_hessian, x_init, prec, iterMax):
    x = np.copy(x_init)
    g, H = f_grad_hessian(x_init)
    epsilon = prec * np.linalg.norm(g)
    x_tab = np.copy(x)

    print("------------------------------------\nDamped Newton (Wolfe)\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g, H = f_grad_hessian(x)

        try:
            d_newton = np.linalg.solve(H, g)
            if np.dot(g, d_newton) > 0:
                d = d_newton
            else:
                d = g
        except np.linalg.LinAlgError:
            d = g

        res = line_search(f, lambda xx: f_grad_hessian(xx)[0], x, -d,
                          gfk=None, old_fval=None, old_old_fval=None,
                          args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0]
        if tau is None:
            tau = 1e-4
        x = x - tau * d
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(f_grad_hessian(x)[0])))
    return x, x_tab


def GD_accelerated(f, grad_f, x_init, tau, iterMax, prec, c=0.5):
    epsilon = prec * np.linalg.norm(grad_f(x_init))
    x = np.copy(x_init)
    x_tab = np.copy(x_init)
    y = np.copy(x_init)
    lmbd = 0.0

    print("------------------------------------\n Accelerated GD with constant step size\n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        g = grad_f(y)
        x_new = y - tau * g
        lmbd_new = (1 + np.sqrt(1 + 4 * lmbd**2)) / 2
        y = x_new + (lmbd - 1) / lmbd_new * (x_new - x)

        x = x_new
        lmbd = lmbd_new
        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(grad_f(x))))
    return x, x_tab


def CG_quadratic(A, b, f, grad_f, x_init, iterMax, prec, restarts=0):
    epsilon = prec * np.linalg.norm(grad_f(x_init))
    x = np.copy(x_init)
    x_tab = np.copy(x_init)
    dim = len(x_init)
    total_iters = 0

    print("------------------------------------\n CG for quadratic objective \n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    num_passes = max(restarts, 1)
    for restart in range(num_passes):
        r = -(A @ x + b)
        d = np.copy(r)
        iters_this_pass = min(iterMax - total_iters, dim)

        for k in range(iters_this_pass):
            rr = np.dot(r, r)
            if rr < 1e-30:
                break
            Ad = A @ d
            tau = rr / np.dot(d, Ad)
            x = x + tau * d
            r_new = r - tau * Ad
            beta = np.dot(r_new, r_new) / rr
            d = r_new + beta * d
            r = r_new

            x_tab = np.vstack((x_tab, x))
            total_iters += 1

        if np.linalg.norm(grad_f(x)) < epsilon:
            break
        if total_iters >= iterMax:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        total_iters, t_e - t_s, f(x), np.linalg.norm(grad_f(x))))
    return x, x_tab


def CG_nonLinear(f, grad_f, x_init, iterMax, prec, tau0, rho, c):
    epsilon = prec * np.linalg.norm(grad_f(x_init))
    x = np.copy(x_init)
    x_tab = np.copy(x_init)
    r = -grad_f(x)
    d = np.copy(r)

    print("------------------------------------\n Nonlinear CG (PR+) \n------------------------------------\nSTART")
    t_s = timeit.default_timer()

    for k in range(iterMax):
        tau = tau0
        g = grad_f(x)
        while f(x + tau * d) > f(x) + c * tau * np.dot(g, d):
            tau = rho * tau

        x = x + tau * d
        r_new = -grad_f(x)
        beta = max(np.dot(r_new, r_new - r) / np.dot(r, r), 0.0)
        d = r_new + beta * d
        r = r_new

        x_tab = np.vstack((x_tab, x))

        if np.linalg.norm(grad_f(x)) < epsilon:
            break

    t_e = timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(
        k, t_e - t_s, f(x), np.linalg.norm(grad_f(x))))
    return x, x_tab
