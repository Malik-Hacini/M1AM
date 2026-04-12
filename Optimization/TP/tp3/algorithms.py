import numpy as np
import timeit
from scipy.optimize import line_search






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







def newton(f , f_grad_hessian , x_init , prec , iterMax ):
    x = np.copy(x_init)
    g,H = f_grad_hessian(x_init)
    epsilon = prec*np.linalg.norm(g)

    x_tab = np.copy(x)
    print("------------------------------------\nNewton's algorithm\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()
    for k in range(iterMax):

        g,H = f_grad_hessian(x)
        x = x - np.linalg.solve(H,g)  

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(g)))
    return x,x_tab









def bfgs(f , f_grad , x_init , prec , iterMax ):

    x = np.copy(x_init)
    g = f_grad(x_init)
    epsilon = prec*np.linalg.norm(g)

    I = np.eye(len(x))
    W = np.copy(I)

    x_tab = np.copy(x)
    print("------------------------------------\nBFGS algorithm\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        d = W@g

        res = line_search(f, f_grad, x, -d, gfk=None, old_fval=None, old_old_fval=None, args=(), c1=0.0001, c2=0.9, amax=50)
        tau = res[0]

        x_new = x - tau*d
        g_new = f_grad(x_new)

        # TO DO: UPDATE THE MATRIX W
        
        x = x_new
        g = g_new


        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(g)))
    return x,x_tab





