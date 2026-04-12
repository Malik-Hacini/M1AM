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

        g = grad_f_subsampling(x)
        x_new = x - tau*g 

        x_tab = np.vstack((x_tab,x_new))

        x_sum = x_sum + tau*x
        tau_sum = tau_sum + tau
        x_avg = (1 / tau_sum)*x_sum
        x_avg_tab = np.vstack((x_avg_tab,x_avg))

        x = x_new

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x_avg)))
    
    return x,x_tab,x_avg, x_avg_tab






def adagrad_norm(f, grad_f_subsampling, x_init, tau, b_sq, iterMax):
    
    x = np.copy(x_init)
    x_tab = np.copy(x)
    

    ### TO BE COMPLETED

    print("------------------------------------\n Adagrad-norm \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

        x_tab = np.vstack((x_tab,x))

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))
    
    return x,x_tab



def adagrad_diag(f, grad_f_subsampling, x_init, tau, b_sq, iterMax):
    
    x = np.copy(x_init)
    x_tab = np.copy(x)
    
    ### TO BE COMPLETED

    print("------------------------------------\n Adagrad \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

        x_tab = np.vstack((x_tab,x))

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))
    
    return x,x_tab



def adam(f, grad_f_subsampling, x_init, tau, beta1, beta2, delta, iterMax):
    
    x = np.copy(x_init)
    x_tab = np.copy(x)

    ### TO BE COMPLETED

    print("------------------------------------\n Adam \n------------------------------------\nSTART")
    t_s =  timeit.default_timer()

    for k in range(iterMax):

        ### TO BE COMPLETED

        x_tab = np.vstack((x_tab,x))

    t_e =  timeit.default_timer()
    print("FINISHED -- {:d} iterations -- {:.6f}s -- final value: {:f}\n\n".format(k,t_e-t_s,f(x)))
    
    return x,x_tab