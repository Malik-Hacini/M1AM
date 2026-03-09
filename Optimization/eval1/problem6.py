import numpy as np


def matrixCond(d,kappa):
    # this function returns a symmetric d*d psd matrix with condition number equal to kappa 

    y = 2.0*(np.random.rand(d) - 0.5)
    I = np.identity(d)
    Y = I - (2.0 / np.inner(y,y)) * np.outer(y,y)
    D = np.diag([np.exp( (i / (d-1)) * np.log(kappa) ) for i in range(d)])

    return Y@D@Y


d = 50
kappa = 10**2

A = matrixCond(d,kappa)
mu = 20.0*(np.random.rand(d) - 0.5) # you are not allowed to use mu to solve the problem
alpha = np.random.rand()


def f(x):
    return 0.5*np.inner((x-mu), A@(x-mu)) + alpha*(d - sum([np.cos(x[i]-mu[i]) for i in range(d)]))
    

def grad_f(x):
    return A@(x-mu) + alpha*np.sin(x-mu)


def hessian_f(x):
    return A + alpha*np.diag(np.cos(x-mu))


def grad_hessian_f(x):
    return grad_f(x), hessian_f(x)

