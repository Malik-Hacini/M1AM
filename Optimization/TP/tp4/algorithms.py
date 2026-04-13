import numpy as np
import timeit



from scipy.optimize import line_search

def GD_wolfe(f , f_grad , x_init , prec, iterMax):
    
    x = np.copy(x_init)
    epsilon = prec*np.linalg.norm(f_grad(x_init) )
    x_tab = np.copy(x)

    print("Gradient with Wolfe line search")
    t_s =  timeit.default_timer()

    for k in range(iterMax):
        g = f_grad(x)

        res = line_search(f, f_grad, x, -g, gfk=None, old_fval=None, old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0] if res[0] is not None else 1.0


        x = x - tau*g 

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(f_grad(x))))
    
    return x,x_tab


def GD(f, f_grad, x_init, tau, iterMax, prec):

    epsilon = prec*np.linalg.norm(f_grad(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)


    print("GD with constant step size")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        g = f_grad(x)
        x = x - tau*g

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(f_grad(x))))
    
    return x,x_tab






def GD_accelerated(f, grad_f, x_init, tau, iterMax, prec, c=0.5):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    y = np.copy(x_init)
    lmbd = 0.0


    print("Accelerated GD with constant step size")
    t_s =  timeit.default_timer()

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

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab



def CG_quadratic(A, b, f, grad_f, x_init, iterMax, prec):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    r = -(A@x + b)
    d = r

    print("CG for quadratic objective")
    t_s =  timeit.default_timer()

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


    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab



def CG_nonLinear(f, grad_f, x_init, iterMax, prec, tau0, rho, c):

    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    r = -grad_f(x)
    d = r

    print("CG for quadratic objective")
    t_s =  timeit.default_timer()

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


    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab
