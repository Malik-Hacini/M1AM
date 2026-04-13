import numpy as np


def matrixCond(d,kappa):
    # this function returns a symmetric d*d psd matrix with condition number equal to kappa 

    y = 2.0*(np.random.rand(d) - 0.5)
    I = np.identity(d)
    Y = I - (2.0 / np.inner(y,y)) * np.outer(y,y)
    D = np.diag([np.exp( (i / (d-1)) * np.log(kappa) ) for i in range(d)])

    return Y@D@Y


d = 20
kappa = 100

prec = matrixCond(d,kappa)
mu = 20.0*(np.random.rand(d) - 0.5) 
nu = 3.0

# you are only allowed to use the following functions

def f(x):
    return np.log( 1.0 + (1/nu)*np.inner(x-mu, prec@(x-mu)))


def grad_f(x):
    num = 2*prec@(x - mu)
    den = nu + np.inner(x-mu, prec@(x-mu))

    return (1/den) * num + np.random.standard_t(2,d)


    
