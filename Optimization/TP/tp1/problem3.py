import numpy as np

# Oracles of the Himmelblau function

def f(x):
    return (x[0]**2 + x[1] - 11)**2 + (x[0] + x[1]**2 - 7)**2


### TO DO: IMPLEMENT FIRST-ORDER AND SECOND-ORDER oracles


# useful constants for plotting

lb = -5.0
ub = 5.0
nb_points = 100
levels = [0.0, 3.0, 15.0, 65.0, 180.0, 300.0]
