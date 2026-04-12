import numpy as np

# Oracles of the Himmelblau function

def f(x):
    return (x[0]**2 + x[1] - 11)**2 + (x[0] + x[1]**2 - 7)**2


def grad_f(x):
    x1, x2 = x
    return np.array([
        4*x1*(x1**2 + x2 - 11) + 2*(x1 + x2**2 - 7),
        2*(x1**2 + x2 - 11) + 4*x2*(x1 + x2**2 - 7)
    ])


def hessian_f(x):
    x1, x2 = x
    return np.array([
        [12*x1**2 + 4*x2 - 42, 4*(x1 + x2)],
        [4*(x1 + x2), 12*x2**2 + 4*x1 - 26]
    ])


# useful constants for plotting

lb = -5.0
ub = 5.0
nb_points = 100
levels = [0.0, 3.0, 15.0, 65.0, 180.0, 300.0]
