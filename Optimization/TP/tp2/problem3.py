import numpy as np



def matrixCond(d,kappa):
    # this function returns a symmetric d*d psd matrix with condition number equal to kappa 

    y = 2.0*(np.random.rand(d) - 0.5)
    I = np.identity(d)
    Y = I - (2.0 / np.inner(y,y)) * np.outer(y,y)
    D = np.diag([np.exp( (i / (d-1)) * np.log(kappa) ) for i in range(d)])

    return Y@D@Y



d = 1000
kappa = 10**6

A = matrixCond(d,kappa)
x_star = 20.0*(np.random.rand(d) - 0.5)
b = -A@x_star
c = 0.5*np.inner(x_star, A@x_star)
# the parameters b and c are adjusted backwards, so that f_3 takes non-negative values

# zeroth-order oracle
def f(x):
    return 0.5*np.inner(x, A@x) + np.inner(b,x) + c
    
# first-order oracle
def grad_f(x):
    return A@x + b

# second-order oracle
def hessian_f(x):
    return A

