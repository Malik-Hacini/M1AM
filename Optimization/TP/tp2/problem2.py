import numpy as np

# oracles associated with the Rosenbrock function f_2.

def f(x):
    return 100*(x[1] - x[0]**2)**2 + (1 - x[0])**2



def grad_f(x):
    x1 = x[0]
    x2 = x[1]
    g1 = 100*2*(x2 - x1**2)*(-2)*x1 -2*(1-x1)
    g2 = 200*(x2 - x1**2)
    return np.array([g1,g2])


def hessian_f(x):
    x1 = x[0]
    x2 = x[1]
    return np.array([[1200*x1**2 - 400*x2 + 2, -400*x1], [-400*x1, 200]])


# useful constants for plotting
lb = -5.0
ub = 5.0
nb_points = 500
levels = [0.0, 5.0, 50.0, 300.0, 800.0]
