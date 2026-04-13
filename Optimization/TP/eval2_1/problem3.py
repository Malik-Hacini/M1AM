import numpy as np


d = 100
x_star = 20.0*(np.random.rand(d) - 0.5) 
alpha = 10.0*np.random.rand(d)
epsilon = np.random.rand()


# you are only allowed to use the following functions

def f(x):
    return sum([(alpha[i]**2)*( np.sqrt(1 + ((x[i] - x_star[i])/alpha[i])**2) - 1 ) for i in range(d)])

def g(x):
    return max(np.linalg.norm(x)-epsilon,0)

def F(x):
    return f(x) + g(x)


def grad_f(x):
    res = np.zeros(d)
    for i in range(d):
        res[i] = 2*(x[i] - x_star[i]) / np.sqrt( 1 + ((x[i] - x_star[i])/alpha[i])**2 )
    
    return res


