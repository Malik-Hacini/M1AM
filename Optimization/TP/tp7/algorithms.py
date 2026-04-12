import numpy as np
import timeit


def proj_GD(f, grad_f, proj, x_init, tau, iterMax, prec):
    
    epsilon = prec*np.linalg.norm(grad_f(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("------------------------------------\n GD with constant step size\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        # TO BE COMPLETED

        x_tab = np.vstack((x_tab,x))

        if ### TO BE COMPLETED
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab




def POCS(proj, x_init, iterMax):
    x = np.copy(x_init)
    x_tab = np.copy(x_init)

    print("------------------------------------\n POCS \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        x = proj(x)

        x_tab = np.vstack((x_tab,x))

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s \n\n".format(k,t_e-t_s))
    
    return x,x_tab

