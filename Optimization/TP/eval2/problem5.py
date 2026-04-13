import numpy as np


def matrixCond(d,kappa):
    # this function returns a symmetric d*d psd matrix with condition number equal to kappa 

    y = 2.0*(np.random.rand(d) - 0.5)
    I = np.identity(d)
    Y = I - (2.0 / np.inner(y,y)) * np.outer(y,y)
    D = np.diag([np.exp( (i / (d-1)) * np.log(kappa) ) for i in range(d)])

    return Y@D@Y




d = 100
c = 5.0*(np.random.rand(d) - 0.5) 

def f(x):
    return np.inner(c,x) + np.linalg.norm(c)

def grad_f(x):
    return c

