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
    return sum([np.exp(-0.1*t)*u[t] for t in range(T)])

### TO BE COMPLETED






