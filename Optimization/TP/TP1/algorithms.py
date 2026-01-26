import numpy as np
from scipy.optimize import minimize


def BFGS(f, grad_f, x_init):
    res = minimize(f, x_init, method='BFGS', jac=grad_f, options={'disp': True})
    return res.x