import numpy as np
import timeit



def GD(f, grad_f, x_init, tau, iterMax, prec):

    epsilon = prec*np.linalg.norm(f_grad(x_init))

    x = np.copy(x_init)
    x_tab = np.copy(x_init)


    print("------------------------------------\n GD with constant step size\n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        g = grad_f(x)
        x = x - tau*g

        x_tab = np.vstack((x_tab,x))

        if np.linalg.norm(g) < epsilon:
            break

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f} -- final gradient norm: {:f} \n\n".format(k,t_e-t_s,f(x),np.linalg.norm(grad_f(x))))
    
    return x,x_tab




def SGD(f, grad_f_subsampling, x_init, tau0, schedule, iterMax):
    # returns the sequence of iterates as well as the sequence of averaged iterates
    
    x = np.copy(x_init)
    x_tab = np.copy(x)
    tau = np.copy(tau0)

    x_avg = np.copy(x)
    x_avg_tab = np.copy(x_avg)
    x_sum = np.zeros(len(x_init))
    tau_sum = 0.0

    print("------------------------------------\n Stochastic gradient descent \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        if schedule == "decreasing":
            tau = 1 / (k+1)

        # TO COMPLETE


    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x_avg)))
    
    return x,x_tab,x_avg, x_avg_tab




