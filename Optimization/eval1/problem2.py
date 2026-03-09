import numpy as np


d = 100
x_star = 20.0*(np.random.rand(d) - 0.5) # you are not allowed to use x_star to solve the problem
alpha = 10.0*np.random.rand(d)


def f(x):
    return sum([(alpha[i]**2)*( np.sqrt(1 + ((x[i] - x_star[i])/alpha[i])**2) - 1 ) for i in range(d)])


def grad_f(x):
    res = np.zeros(d)
    for i in range(d):
        res[i] = 2*(x[i] - x_star[i]) / np.sqrt( 1 + ((x[i] - x_star[i])/alpha[i])**2 )
    
    return res


def hessian_f(x):
    res = np.zeros(d)
    for i in range(d):
        res[i] = 2 / np.sqrt( 1 + ((x[i] - x_star[i])/alpha[i])**2 ) - (4*(x[i] - x_star[i])**2) / ( (alpha[i]**2) * (1 + ((x[i] - x_star[i])/alpha[i])**2)**(3/2) )

    return np.diag(res)


def grad_hessian_f(x):
    return grad_f(x), hessian_f(x) 


    
