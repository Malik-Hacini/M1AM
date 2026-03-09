---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.19.1
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

## Eval 1

The goal of this evaluation is to solve six unconstrained optimization problem (whose oracles are given) using the algorithms you have seen so far in the practical sessions. You can freely re-use your notes and implemented algorithms from the previous practical sessions. 

When working on problem number $i$, you should:
- look into the file `problemi.py` to observe the properties of the problem at hand, 
- select which algorithm is, in your opinion, best suited for this problem based on these properties,
- justify this choice,
- run the algorithm,
- comment on the observed performance.

Initialise the algorithms from $x_0 = 0$. If for some reason, you need an alternative initialization, explain why this is the case and include the run initialized at $x_0 = 0$. You can reuse the variables used to construct the problems and the associated oracles, except those for which a comment explicitly says otherwise. If you perform some pen-and-paper calculations, you do not have to write down all the details in the notebook: just explain what you were trying to compute, how you computed it, and the result you obtained. The choice of hyper-parameters (stopping criterion, step-size,...) is up to you and should be justified.

At the end of the session (i.e., before 11:15), send me an email to `thomas.guilmeau@inria.fr` with object `NumOpt - eval1 - yourFirstName_yourSurname` with an attached archive named `yourFirstName_yourSurname` containing this notebook with your explainations and runs, the problem files, the `utils.py` file, as well as the `algorithms.py` files that you have used. I should be able to run your notebook again and obtain the same results as you.

*Some advice:*

If you realise that maybe another algorithm is a better choice, or if you think that two algorithms may have similar performance, you can explain why you think so, run both algorithms, and compare their performance. Some problems are harder than others, so if you do not manage to solve exactly the problem, you can explain why the algorithms you have considered do not work and move on to the next problems. All problems are such that $\min f = 0$.

```python
from utils import *
from algorithms import *
```

### Problem 1

```python
import problem1 as pb1
```
We have $f(x) = \frac{1}{2} x^\top A x + b^\top x + c$ with $A \succ 0$, $d = 500$, and $\kappa(A) = 10^6$. This is a strictly convex quadratic, so the unique minimizer satisfies $Ax^* + b = 0$.

We use conjugate gradient for quadratic objectives with restarts. CG terminates in at most $d$ iterations in exact arithmetic and only requires one matrix-vector product per iteration ($O(d^2)$), avoiding the $O(d^3)$ factorization that Newton would need. Its convergence satisfies $\|x_k - x^*\|_A \le 2 \left(\frac{\sqrt{\kappa} - 1}{\sqrt{\kappa} + 1}\right)^k \|x_0 - x^*\|_A$, which is far better than GD's rate $\left(\frac{\kappa - 1}{\kappa + 1}\right)^k \approx (1 - 2 \times 10^{-6})^k$. However, with $\kappa = 10^6$, floating-point errors destroy conjugacy well before $d$ iterations complete: a single CG pass only reaches $f \approx 900$. By restarting CG every $d$ iterations we recover conjugacy and reach machine precision after about 15 to 17 restarts.

We set `prec=1e-10` (relative stopping criterion on the gradient norm), `restarts=20`, and `iterMax=10000`.

```python
x0 = np.zeros(pb1.d)

x1, x1_tab = CG_quadratic(pb1.A, pb1.b, pb1.f, pb1.grad_f, x0,
                           iterMax=10000, prec=1e-10, restarts=20)

print(f"f(x*) = {pb1.f(x1)}")
print(f"||grad f(x*)|| = {np.linalg.norm(pb1.grad_f(x1))}")
```

```python
plot_obj_normGrad(x1_tab, pb1.f, pb1.grad_f, "Problem 1: CG quadratic (with restarts)")
```

CG with restarts converges to $f \approx 0$ after approximately 8500 iterations (17 restarts of 500). 


### Problem 2

```python
import problem2 as pb2
```

We have $f(x) = \sum_{i=1}^{d} \alpha_i^2 \left( \sqrt{1 + \left(\frac{x_i - x_i^*}{\alpha_i}\right)^2} - 1 \right)$ with $d = 100$. The function is smooth, convex, and separable with a diagonal Hessian.

We use gradient descent with Wolfe line search. Pure Newton diverges here because far from $x^*$ the function behaves linearly (like $\alpha_i |t_i|$), so the Hessian entries become very small ($\approx \alpha_i^2 / |t_i|^3$) and the Newton step $H^{-1} g$ becomes enormous. Gradient descent with Wolfe line search adapts naturally to the varying curvature: the line search finds appropriate step sizes both far from $x^*$ (where the function is nearly linear) and near $x^*$ (where it becomes quadratic).

We set `prec=1e-10` and `iterMax=1000`.

```python
x0 = np.zeros(pb2.d)

x2, x2_tab = GD_wolfe(pb2.f, pb2.grad_f, x0, prec=1e-10, iterMax=1000)

print(f"f(x*) = {pb2.f(x2)}")
print(f"||grad f(x*)|| = {np.linalg.norm(pb2.grad_f(x2))}")
```

```python
plot_obj_normGrad(x2_tab, pb2.f, pb2.grad_f, "Problem 2: GD + Wolfe")
```

GD + Wolfe converges to $f = 0$ in very few iterations. 


### Problem 3

```python
import problem3 as pb3
```

We have $f(x) = 2(x_1 - x_1^*)^2 - 1.05(x_1 - x_1^*)^4 + \frac{1}{6}(x_1 - x_1^*)^6 + (x_1 - x_1^*)(x_2 - x_2^*) + (x_2 - x_2^*)^2$ with $d = 2$. The function is smooth but non-convex: the $(1,1)$ entry of the Hessian is $4 - 12.6(x_1 - x_1^*)^2 + 5(x_1 - x_1^*)^4$, which can be negative, leading to multiple stationary points (local minima and saddle points).

We use damped Newton (Newton with Wolfe line search). Since $d = 2$, the Hessian solve is essentially free, and the Wolfe line search provides globalization: when the Hessian is indefinite, the algorithm falls back to a gradient step. From $x_0 = 0$, we expect convergence to a stationary point that may not be the global minimum due to non-convexity. We check the Hessian eigenvalues at the solution to classify it as a local minimum (both $> 0$) or a saddle point (one $< 0$).

We set `prec=1e-10` and `iterMax=1000`.

```python
x0 = np.zeros(pb3.d)

x3, x3_tab = newton_wolfe(pb3.f, pb3.grad_hessian_f, x0, prec=1e-10, iterMax=1000)

print(f"f(x*) = {pb3.f(x3):.6f}")
print(f"x* = {x3}")
print(f"||grad f(x*)|| = {np.linalg.norm(pb3.grad_f(x3)):.2e}")

H = pb3.hessian_f(x3)
eigvals = np.linalg.eigvalsh(H)
print(f"Hessian eigenvalues at x*: {eigvals}")
if np.all(eigvals > 0):
    print("Both positive: this is a local minimum.")
elif np.any(eigvals < 0):
    print("Negative eigenvalue: this is a saddle point.")

if pb3.f(x3) > 1e-6:
    print(f"\nf = {pb3.f(x3):.6f} > 0 => not the global minimum (min f = 0).")
```

From $x_0 = 0$, the algorithm converged to a stationary point with $f > 0$, which is not the global minimum. This is to be expected with non-convex optimization. 

We use the gradient at $x_0 = 0$ to define an alternative starting point $x_0' = -\nabla f(0) / \|\nabla f(0)\|$, a unit step in the steepest descent direction. The goal is to land in a different basin of attraction that leads to the global minimum.

```python
g0 = pb3.grad_f(np.zeros(pb3.d))
x0_alt = -g0 / np.linalg.norm(g0)
print(f"Alternative x0 = {x0_alt}")
print(f"f(x0_alt) = {pb3.f(x0_alt):.6f}")

x3_alt, x3_alt_tab = newton_wolfe(pb3.f, pb3.grad_hessian_f, x0_alt, prec=1e-10, iterMax=1000)

print(f"\nf(x*_alt) = {pb3.f(x3_alt):.6e}")
print(f"x*_alt = {x3_alt}")
print(f"||grad f(x*_alt)|| = {np.linalg.norm(pb3.grad_f(x3_alt)):.2e}")

H_alt = pb3.hessian_f(x3_alt)
eigvals_alt = np.linalg.eigvalsh(H_alt)
print(f"Hessian eigenvalues: {eigvals_alt}")
if pb3.f(x3_alt) < 1e-6 and np.all(eigvals_alt > 0):
    print("Global minimum found (f = 0, Hessian PD).")
elif pb3.f(x3_alt) < 1e-6:
    print("f = 0 reached.")
else:
    print(f"f = {pb3.f(x3_alt):.6f}, still not global min. Trying more alternatives...")
    for x0_try in [np.array([5.0, 5.0]), np.array([-5.0, -5.0]),
                   np.array([10.0, 0.0]), np.array([0.0, 10.0])]:
        x3t, x3t_tab = newton_wolfe(pb3.f, pb3.grad_hessian_f, x0_try,
                                     prec=1e-10, iterMax=1000)
        ft = pb3.f(x3t)
        print(f"  x0={x0_try}: f = {ft:.6e}")
        if ft < pb3.f(x3_alt):
            x3_alt, x3_alt_tab = x3t, x3t_tab
```

```python
level_2points_plot(pb3.f, x3_tab, x3_alt_tab, -15, 15, 200, 20,
                   "Problem 3: x0=0 (green) vs alt init (blue)")
```

From $x_0 = 0$, Newton-Wolfe converges to a non-global stationary point ($f > 0$). The Hessian eigenvalues at this point allow us to classify it as either a local minimum or a saddle point. With an alternative initialization, we reach the global minimum $f = 0$.


### Problem 4

```python
import problem4 as pb4
```

We have $f(x) = \ln\!\left(1 + \frac{1}{\nu} (x - \mu)^\top P (x - \mu)\right)$ with $d = 50$, $\kappa(P) = 10$, $\nu = 3$. The $\ln$ flattens the landscape: at $x_0 = 0$, the function value is around 7.75 but $\|\nabla f(0)\| \approx 0.06$, because $\nabla f = \frac{2P(x-\mu)}{\nu + (x-\mu)^\top P(x-\mu)}$ and the denominator is very large far from $\mu$. The Hessian also has a negative eigenvalue at $x_0 = 0$, so the function is not globally convex. Standard methods (Newton, BFGS, GD+Wolfe) all stall because the gradient is too flat to drive meaningful progress.

However, since $\ln$ is monotone increasing, $\min f(x) \Leftrightarrow \min q(x)$ where $q(x) = (x - \mu)^\top P (x - \mu)$ is a quadratic. We can recover the quadratic parameters without knowing $\mu$: the quadratic has the form $q(x) = \frac{1}{2} x^\top (2P) x + b_q^\top x + \text{const}$ with $b_q = -2P\mu = \nabla q(0)$. Since $\nabla f = \frac{\nabla q}{\nu + q}$, we get $\nabla q(0) = (\nu + q(0)) \cdot \nabla f(0)$, and $q(0) = \nu(e^{f(0)} - 1)$ by inverting the $\ln$. So $A_q = 2P$ = `2 * pb4.prec` and $b_q = (\nu + q(0)) \cdot \nabla f(0)$.

CG on this well-conditioned quadratic ($\kappa = 10$) converges in at most $d = 50$ iterations.

```python
x0 = np.zeros(pb4.d)

f0 = pb4.f(x0)
q0 = pb4.nu * (np.exp(f0) - 1)
grad_q0 = (pb4.nu + q0) * pb4.grad_f(x0)

A_q = 2 * pb4.prec
b_q = grad_q0

def f_q(x):
    return 0.5 * np.dot(x, A_q @ x) + np.dot(b_q, x)

def grad_q(x):
    return A_q @ x + b_q

x4, x4_tab = CG_quadratic(A_q, b_q, f_q, grad_q, x0, iterMax=200, prec=1e-12)

print(f"f(x*) = {pb4.f(x4)}")
print(f"||grad f(x*)|| = {np.linalg.norm(pb4.grad_f(x4))}")
```

```python
plot_obj_normGrad(x4_tab, lambda x: pb4.f(x), pb4.grad_f,
                  "Problem 4: CG on reformulated quadratic")
```

CG on the reformulated quadratic converges to $f = 0$ in about 50 iterations, as expected.


### Problem 5

```python
import problem5 as pb5
```

We have $f(x) = \sum_{i=1}^{d} \alpha_i |x_i - x_i^*|$ with $d = 100$ and $\alpha_i \in [0, 10]$. This is a weighted $\ell_1$ norm, which is convex but non-smooth. No Hessian is provided; `grad_f` returns a subgradient $g(x) = \alpha \odot \operatorname{sign}(x - x^*)$.


We use subgradient descent with a diminishing step size $\tau_k = C / \sqrt{k+1}$, which gives $O(1/\sqrt{k})$ convergence for convex non-smooth problems. We track the best iterate since the method is non-monotone. We chose $C = 2.0$ after testing several values and run for 100000 iterations.

```python
import matplotlib.pyplot as plt

x0 = np.zeros(pb5.d)

def subgradient_descent(f, grad_f, x_init, C, iterMax):
    x = np.copy(x_init)
    x_best = np.copy(x)
    f_best = f(x)
    fvals = [f_best]

    for k in range(iterMax):
        g = grad_f(x)
        tau = C / np.sqrt(k + 1)
        x = x - tau * g
        fval = f(x)
        fvals.append(fval)
        if fval < f_best:
            f_best = fval
            x_best = np.copy(x)

    return x_best, fvals

x5, fvals5 = subgradient_descent(pb5.f, pb5.grad_f, x0, C=2.0, iterMax=100000)
print(f"f(x_best) = {pb5.f(x5):.10f}")
```

```python
f_best_so_far = np.minimum.accumulate(fvals5)
plt.figure()
plt.semilogy(f_best_so_far)
plt.xlabel('k')
plt.ylabel('best f(x_j) so far')
plt.title('Problem 5: Subgradient descent (C=2.0)')
plt.show()
```

The subgradient method achieves a very small $f_{\text{best}}$ after 100k iterations. The convergence is slow ($O(1/\sqrt{k})$), which is inherent to non-smooth optimization.  


### Problem 6

```python
import problem6 as pb6
```

We have $f(x) = \frac{1}{2}(x - \mu)^\top A (x - \mu) + \alpha \left(d - \sum_{i=1}^{d} \cos(x_i - \mu_i)\right)$ with $d = 50$, $\kappa(A) = 100$, and $\alpha \in [0, 1]$. The function is smooth but globally non-convex due to the cosine terms. However, the cosine perturbation is negligible compared to the quadratic term: $A$ has eigenvalues in $[1, 100]$, while each $\alpha_i \cos(\cdot)$ contributes at most $\pm 1$ to the Hessian diagonal. The Hessian $\nabla^2 f = A + \alpha \operatorname{diag}(\cos(x_i - \mu_i))$ therefore remains positive definite along the entire trajectory from $x_0 = 0$.

We use Newton's method. The Hessian is available and PD, $d = 50$ makes the $O(d^3)$ linear solve cheap, and Newton provides quadratic convergence near $\mu$.

We set `prec=1e-10` and `iterMax=1000`.

```python
x0 = np.zeros(pb6.d)

x6, x6_tab = newton(pb6.f, pb6.grad_hessian_f, x0, prec=1e-10, iterMax=1000)

print(f"f(x*) = {pb6.f(x6)}")
print(f"||grad f(x*)|| = {np.linalg.norm(pb6.grad_f(x6))}")
```

```python
plot_obj_normGrad(x6_tab, pb6.f, pb6.grad_f, "Problem 6: Newton")
```

Newton converges to $f = 0$ in just a few iterations. The cosine perturbation could create many local minima in theory, but from $x_0 = 0$ the quadratic term completely dominates the gradient, pulling the iterates straight to the global minimum. The Hessian remains positive definite throughout because $A$'s eigenvalues ($\ge 1$) dominate the cosine perturbation ($\le 1$).
