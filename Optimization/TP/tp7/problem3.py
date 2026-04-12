import numpy as np

T = 52
a = 0.15
alpha = 1.0
u_threshold = 6.0
x_threshold = 1.0

def u_from_x(x):
    u = np.zeros(T)
    for t in range(T):
        u[t] = (1+a)*x[t] - x[t+1]

    return u

def cumulated_catch(u):
    return sum([np.exp(-alpha*t)*u[t] for t in range(T)])

discount = np.exp(-alpha*np.arange(T))
catch_v = np.zeros(T+1)
catch_v[:-1] += (1+a)*discount
catch_v[1:] -= discount


def proj_halfspace(x, v, w):
    if np.inner(v,x) <= w:
        return np.copy(x)
    return x - (np.inner(v,x) - w)*v/np.inner(v,v)


def proj_hyperplane(x, v, w):
    return x - (np.inner(v,x) - w)*v/np.inner(v,v)


def proj_stock(x, t):
    y = np.copy(x)
    y[t] = max(y[t], x_threshold)
    return y


def proj_periodicity(x):
    v = np.zeros(T+1)
    v[0] = 1.0
    v[T] = -1.0
    return proj_hyperplane(x, v, 0.0)


def proj_control(x, t):
    v = np.zeros(T+1)
    v[t] = -(1+a)
    v[t+1] = 1.0
    return proj_halfspace(x, v, 0.0)


def proj_catch(x):
    return proj_halfspace(x, -catch_v, -u_threshold)


def proj(x):
    y = np.copy(x)
    for t in range(T+1):
        y = proj_stock(y, t)
    y = proj_periodicity(y)
    for t in range(T):
        y = proj_control(y, t)
    y = proj_catch(y)
    return y




