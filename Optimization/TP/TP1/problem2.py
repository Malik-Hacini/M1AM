import numpy as np

# oracles associated with the Rosenbrock function f_2.

def f(x):
    return 100*(x[1] - x[0]**2)**2 + (1 - x[0])**2



### TO DO: IMPLEMENT FIRST-ORDER AND SECOND-ORDER oracles


# useful constants for plotting
lb = -5.0
ub = 5.0
nb_points = 500
levels = [0.0, 5.0, 50.0, 300.0, 800.0]


