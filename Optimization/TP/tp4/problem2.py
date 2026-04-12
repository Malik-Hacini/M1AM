import numpy as np



def u(t):
    if t < 0.5:
        res = np.sqrt(t)
    else:
        res = 0.5 + 2*np.abs(t - 0.75)

    return res


N = 100
h = 1.0/N

x_hat = np.array([u(t) + 0.1*np.random.normal() for t in np.linspace(0.0,1.0,N+1)])

alpha = 0.001
beta = 2

def f(x):
    return (h/4)*(x[0] - x_hat[0])**2 + (h/4)*(x[N] - x_hat[N])**2 + (h/2)*sum( [(x[i] - x_hat[i])**2 for i in range(1,N)] ) + (alpha/beta)*(h**(1-beta))*sum([(x[i] - x[i+1])**beta for i in range(N)])
    


def grad_f(x):

    res = np.zeros(np.size(x))

    cst = alpha*(h**(1-beta))

    for i in range(N+1):

        if i == 0:
            res[i] += (h/2)*(x[0] - x_hat[0]) + cst*(x[0] - x[1])**(beta-1)
        elif i < N:
            res[i] +=  h*(x[i] - x_hat[i]) + cst*( (x[i] - x[i+1])**(beta-1) - (x[i-1] - x[i])**(beta-1) )
        else:
            res[i] += (h/2)*(x[N] - x_hat[N]) -cst*(x[N-1] - x[N])**(beta-1)

    return res






diag = np.ones(N-1)
diag = np.hstack((np.array([0.5]), diag, np.array([0.5])))
A1 = 0.5*np.diag(diag)
A2 = 2*np.diag(diag)

for i in range(0,N):
    A2[i,i+1] = -1

for i in range(1,N+1):
    A2[i,i-1] = -1


A = 2 * ( h*A1 + (alpha/beta)*(h**(1-beta))*A2 )
b = -2*(h*A1 @ x_hat)
c = np.inner(x_hat, h*A1@x_hat)
