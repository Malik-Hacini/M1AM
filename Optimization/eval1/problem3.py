import numpy as np


d = 2
x_star = 20.0*(np.random.rand(d) - 0.5) # you are not allowed to use x_star to solve the problem


def f(x):
    return 2*(x[0]-x_star[0])**2 - 1.05*(x[0]-x_star[0])**4 + (1/6)*(x[0]-x_star[0])**6 + (x[0]-x_star[0])*(x[1]-x_star[1]) + (x[1]-x_star[1])**2


def grad_f(x):
    res = np.zeros(d)
    res[0] = 4*(x[0]-x_star[0]) - 4.2*(x[0]-x_star[0])**3 + (x[0]-x_star[0])**5 + (x[1]-x_star[1])
    res[1] = (x[0]-x_star[0]) + 2*(x[1]-x_star[1])

    return res


def hessian_f(x):
    res = np.zeros((d,d))
    res[0,0] = 4 - 12.6*(x[0]-x_star[0])**2 + 5*(x[0]-x_star[0])**4
    res[0,1] = 1
    res[1,0] = 1
    res[1,1] = 2
    return res


def grad_hessian_f(x):
    return grad_f(x), hessian_f(x)

