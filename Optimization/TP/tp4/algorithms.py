import numpy as np
import timeit



from scipy.optimize import line_search

def GD_wolfe(f , f_grad , x_init , prec, iterMax):
    
    x = np.copy(x_init)
    epsilon = prec*np.linalg.norm(f_grad(x_init) )
    x_tab = np.copy(x)

    print("------------------------------------\n Gradient with Wolfe line search\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):
        g = f_grad(x)

        res = line_search(f, f_grad, x, -g, gfk=None, old_fval=None, old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0]


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


    print("------------------------------------\n GD with constant step size\n------------------------------------\nSTART")
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


    print("------------------------------------\n Accelerated GD with constant step size\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

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

    print("------------------------------------\n CG for quadratic objective \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

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

    print("------------------------------------\n CG for quadratic objective \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

        if np.linalg.norm(grad_f(x)) < epsilon:
            break


    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab

