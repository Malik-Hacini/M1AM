import numpy as np

#implement oracles associated with the quadratic function f_1.

# zeroth-order oracle
def f(x):
    return 0.5*(1.5*x[0]**2 + 3.0*x[0]*x[1] + 3.0*x[1]**2)
    
# first-order oracle
def grad_f(x):
    return np.array([1.5*x[0] + 1.5*x[1], 3.0*x[1] + 1.5*x[0]])

# second-order oracle
def hessian_f(x):
    return np.array([[1.5, 1.5], [1.5, 3.0]])



# Some useful constants for plotting
lb = -5.0
ub = 5.0
nb_points = 100
levels = [0.0, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0]
