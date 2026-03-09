import numpy as np


d = 100
x_star = 20.0*(np.random.rand(d) - 0.5) # you are not allowed to use x_star to solve the problem
alpha = 10.0*np.random.rand(d)


def f(x):
    return sum([alpha[i]*np.abs(x[i] - x_star[i]) for i in range(d)])


def grad_f(x):
    return alpha*np.sign(x - x_star)
    
