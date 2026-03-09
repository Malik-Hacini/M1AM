import numpy as np


def matrixCond(d,kappa):
    # this function returns a symmetric d*d psd matrix with condition number equal to kappa 

    y = 2.0*(np.random.rand(d) - 0.5)
    I = np.identity(d)
    Y = I - (2.0 / np.inner(y,y)) * np.outer(y,y)
    D = np.diag([np.exp( (i / (d-1)) * np.log(kappa) ) for i in range(d)])

    return Y@D@Y


d = 50
kappa = 10

prec = matrixCond(d,kappa)
mu = 20.0*(np.random.rand(d) - 0.5) # you are not allowed to use mu to solve the problem
nu = 3.0


def f(x):
    return np.log( 1.0 + (1/nu)*np.inner(x-mu, prec@(x-mu)))


def grad_f(x):
    num = 2*prec@(x - mu)
    den = nu + np.inner(x-mu, prec@(x-mu))

    return (1/den) * num


def hessian_f(x):
    den = nu + np.inner(x-mu, prec@(x-mu))
    return (1/den)*2*prec - (1/den**2)*4*np.outer(prec@(x-mu),prec@(x-mu))


def grad_hessian_f(x):
    return grad_f(x), hessian_f(x)



