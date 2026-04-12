# Algorithms Reference

This file summarizes the algorithms studied through `tp1` to `tp7` and gives a practical rule for choosing between them.

## Notation

We consider the following problem classes.

- Unconstrained smooth optimization:
  $$
  \min_{x \in \mathbb{R}^d} f(x)
  $$
- Finite-sum stochastic optimization:
  $$
  f(x) = \frac1m \sum_{i=1}^m f_i(x)
  $$
- Constrained smooth optimization:
  $$
  \min_{x \in C} f(x)
  $$
- Feasibility problems:
  $$
  \text{find } x \in \bigcap_{i=1}^p C_i
  $$

Notation used below:

- $g_k = \nabla f(x_k)$
- $H_k = \nabla^2 f(x_k)$
- $L$: Lipschitz constant of $\nabla f$
- $\mu$: strong convexity constant
- $\kappa = L / \mu$: condition number when $\mu > 0$
- $G(x)$: unbiased stochastic gradient, with $\mathbb{E}[G(x)] = \nabla f(x)$

## Choice Guide

| Problem structure | First algorithm to test | Why | If not good enough |
| --- | --- | --- | --- |
| Smooth convex, full gradient cheap, $L$ known | `GD` with $\tau = 1/L$ | simplest stable baseline | `GD_accelerated`, `bfgs`, `newton` |
| Smooth convex, $L$ unknown | `GD_backtracking` | descent without estimating $L$ | `GD_wolfe`, `bfgs`, `newton_wolfe` |
| Symmetric positive definite quadratic | `CG_quadratic` | exploits quadratic structure, usually much faster than GD | `GD_exact` only as a baseline |
| Smooth, ill-conditioned convex | `GD_accelerated` | better complexity than GD | `bfgs` or `newton` if dimension is moderate |
| Smooth nonconvex, Hessian unavailable | `bfgs` or `GD_wolfe` | robust descent methods | `newton_wolfe` if Hessian can be computed |
| Smooth, Hessian available, moderate dimension | `newton_wolfe` | strong local convergence, safer than raw Newton | raw `newton` near a good initialization |
| Finite-sum / noisy gradient, large $m$ | `SGD` | cheapest iteration | `adagrad_diag`, `adam` |
| Stochastic problem with anisotropic coordinates | `adagrad_diag` | coordinate-wise scaling | `adam` |
| Constrained smooth problem with easy projection | `proj_GD` | natural extension of GD | reformulate or use another constrained method if projection is hard |
| Intersection of simple sets, goal is feasibility | `POCS` | each individual projection is easy | use a dedicated constrained optimizer if an objective also matters |

## Questions To Ask Before Choosing

1. Is the problem deterministic or stochastic?
2. Is it unconstrained, constrained, or pure feasibility?
3. Is the objective quadratic, or only smooth?
4. Can $L$ be estimated?
5. Is the Hessian available and affordable?
6. Is the dimension small enough for dense matrix methods?
7. Is the main difficulty ill-conditioning, noise, or constraints?

The choice should follow the structure, not personal preference.

## Algorithm Cards

### Gradient Descent With Fixed Step Size

Update:

$$
x_{k+1} = x_k - \tau \nabla f(x_k)
$$

Best use case:

- smooth deterministic problems,
- full gradient cheap,
- either $L$ is known or a safe step can be estimated.

Theory:

- If $f$ is convex and $L$-smooth, any $\tau \le 1/L$ gives descent.
- If $f$ is convex:
  $$
  f(x_k) - f(x_*) = O(1/k)
  $$
- If $f$ is $\mu$-strongly convex and $\tau = 1/L$:
  $$
  \|x_k - x_*\|^2 \le (1-\mu/L)^k \|x_0 - x_*\|^2
  $$

Pros:

- minimal implementation,
- cheap iteration,
- clean baseline for every smooth problem.

Cons:

- highly sensitive to step size,
- slow on ill-conditioned problems,
- no adaptation to local geometry.

Use it when:

- you want the first reference result,
- you know $L$ or can upper-bound it,
- the problem is not too ill-conditioned.

### Gradient Descent With Backtracking Line Search

Direction:

$$
d_k = -\nabla f(x_k)
$$

Armijo condition:

$$
f(x_k + \tau d_k) \le f(x_k) + c\tau \nabla f(x_k)^\top d_k
$$

with $c \in (0,1)$ and $d_k$ a descent direction.

Best use case:

- smooth deterministic problems,
- $L$ unknown,
- need automatic step-size selection.

Pros:

- usually guarantees descent,
- removes the need to know $L$,
- easy to attach to other methods.

Cons:

- extra function evaluations,
- can accept overly small steps,
- slower than a well-tuned fixed step on easy problems.

Use it when:

- you do not trust a fixed step,
- you need a robust default method,
- you want a safe first run on a new objective.

### Gradient Descent With Exact Line Search On Quadratics

For a quadratic function

$$
f(x)=\tfrac12 x^\top A x + b^\top x + c,
$$

the steepest-descent step that minimizes along $-g_k$ is

$$
\tau_k = \frac{\|g_k\|^2}{g_k^\top A g_k}.
$$

Best use case:

- symmetric positive definite quadratic objectives,
- mainly as a benchmark.

Theory:

- For SPD quadratics, steepest descent with exact line search has linear convergence.
- The asymptotic factor is governed by
  $$
  \left(\frac{\kappa-1}{\kappa+1}\right)^2.
  $$

Pros:

- best possible step along the gradient direction,
- simple closed form for quadratics.

Cons:

- only really useful for quadratics,
- still much slower than conjugate gradient when $\kappa$ is large.

Use it when:

- you want a reference algorithm on SPD quadratics,
- you want to compare steepest descent to conjugate gradient.

### Gradient Descent With Wolfe Line Search

Wolfe line search chooses $\tau_k$ so that both sufficient decrease and curvature are controlled.

Typical conditions:

$$
f(x_k+\tau_k d_k) \le f(x_k) + c_1 \tau_k \nabla f(x_k)^\top d_k
$$

and

$$
|\nabla f(x_k+\tau_k d_k)^\top d_k| \le c_2 |\nabla f(x_k)^\top d_k|.
$$

Best use case:

- smooth deterministic problems,
- especially as the line-search subroutine of `bfgs` and `newton_wolfe`.

Pros:

- safer than fixed-step GD,
- avoids excessively small steps better than pure Armijo,
- preserves curvature information needed by quasi-Newton methods.

Cons:

- more expensive than fixed-step GD,
- still first-order, so may remain slow on ill-conditioned problems.

Use it when:

- you need a robust line search,
- you plan to use `bfgs` or `newton_wolfe`.

### Newton's Method

Update:

$$
x_{k+1} = x_k - H_k^{-1} g_k
$$

Best use case:

- smooth problems,
- Hessian available,
- moderate dimension,
- initialization already reasonably close to a solution.

Theory:

- If $x_0$ is close enough to a nondegenerate minimizer and $\nabla^2 f$ is Lipschitz near it, Newton has local quadratic convergence:
  $$
  \|x_{k+1}-x_*\| \le C \|x_k-x_*\|^2.
  $$

Pros:

- extremely fast near the solution,
- uses curvature directly.

Cons:

- each iteration is expensive,
- requires Hessian computation and a linear solve,
- may fail if the Hessian is singular or indefinite,
- not globally robust without globalization.

Use it when:

- $d$ is moderate,
- Hessians are available,
- you already have a good initialization.

### Newton With Wolfe Line Search

Update:

$$
x_{k+1} = x_k - \tau_k H_k^{-1} g_k
$$

with $\tau_k$ obtained by Wolfe line search.

Best use case:

- same setting as Newton,
- but when the initialization may be poor.

Pros:

- much more robust than raw Newton,
- retains Newton's fast local behavior once the method reaches the right regime.

Cons:

- still needs Hessian access,
- line search adds cost,
- if the Hessian is very bad far from the solution, other safeguards may still be needed.

Use it when:

- you want Newton's speed without relying on a near-perfect starting point.

### BFGS

Direction:

$$
d_k = -W_k g_k
$$

where $W_k$ approximates $H_k^{-1}$.

Update:

$$
W_{k+1} = \left(I - \frac{s_k y_k^\top}{y_k^\top s_k}\right)W_k\left(I - \frac{y_k s_k^\top}{y_k^\top s_k}\right) + \frac{s_k s_k^\top}{y_k^\top s_k}
$$

with

$$
s_k = x_{k+1}-x_k, \qquad y_k = g_{k+1}-g_k.
$$

Best use case:

- smooth deterministic problems,
- Hessian unavailable or too expensive,
- moderate dimension.

Theory:

- Under standard assumptions and with a Wolfe line search, BFGS has local superlinear convergence on smooth strongly convex problems.

Pros:

- much faster than GD in many smooth problems,
- no Hessian needed,
- often the best practical deterministic choice in moderate dimension.

Cons:

- dense memory cost $O(d^2)$,
- weaker performance in very high dimension,
- less natural in noisy stochastic settings.

Use it when:

- the problem is smooth and deterministic,
- $d$ is not too large,
- you want a strong default method without second-order coding.

### Accelerated Gradient Descent

Canonical convex form:

$$
\begin{aligned}
x_{k+1} &= y_k - \tau \nabla f(y_k), \\
y_{k+1} &= x_{k+1} + \beta_k (x_{k+1} - x_k).
\end{aligned}
$$

Best use case:

- smooth convex deterministic problems,
- especially when the issue is ill-conditioning and $L$ is known.

Theory:

- For convex $L$-smooth problems:
  $$
  f(x_k)-f(x_*) = O(1/k^2)
  $$
  instead of $O(1/k)$ for plain GD.

Pros:

- better complexity than GD,
- very attractive on large smooth convex problems.

Cons:

- more sensitive to modeling error and noise,
- less robust than BFGS/Newton when the problem is not a clean smooth convex one,
- step-size tuning matters.

Use it when:

- the objective is smooth and convex,
- full gradients are available,
- GD is too slow because of conditioning.

### Conjugate Gradient For Quadratics

Problem form:

$$
\min_x \tfrac12 x^\top A x + b^\top x + c
$$

with $A$ symmetric positive definite.

The method builds $A$-conjugate directions rather than repeatedly using the gradient direction.

Best use case:

- large SPD quadratic problems,
- linear systems $Ax = -b$,
- matrix-vector products are cheap.

Theory:

- Exact arithmetic: solution in at most $d$ iterations.
- Rate in the $A$-norm:
  $$
  \|x_k-x_*\|_A \le 2\left(\frac{\sqrt{\kappa}-1}{\sqrt{\kappa}+1}\right)^k \|x_0-x_*\|_A.
  $$

Pros:

- dramatically better than GD on SPD quadratics,
- low memory,
- exploits structure perfectly.

Cons:

- tied to quadratic/SPD structure,
- loses its best guarantees outside that setting.

Use it when:

- the problem is exactly or essentially an SPD quadratic.

### Nonlinear Conjugate Gradient

Generic update:

$$
d_{k+1} = -g_{k+1} + \beta_k d_k
$$

with a scalar choice such as Fletcher-Reeves or Polak-Ribiere+, and a line search.

Best use case:

- smooth large-scale deterministic optimization,
- when memory must stay very small.

Pros:

- cheaper than BFGS in memory,
- often better than plain GD,
- simple to implement.

Cons:

- more delicate than quadratic CG,
- performance depends strongly on the line search and on the chosen $\beta_k$,
- usually less reliable than BFGS on moderate-size smooth problems.

Use it when:

- the dimension is too large for dense quasi-Newton matrices,
- but the problem is still smooth and deterministic.

### Stochastic Gradient Descent

Update:

$$
x_{k+1} = x_k - \tau_k G(x_k)
$$

with $\mathbb{E}[G(x_k)] = \nabla f(x_k)$.

Best use case:

- finite-sum problems with large $m$,
- full gradient too expensive,
- cheap stochastic gradient available.

Theory:

- Constant step size gives fast transient progress but a noise floor.
- Decreasing step sizes give convergence but slower practical progress.
- For convex problems, averaged iterates often satisfy the cleanest guarantees.

Typical bound for averaged iterates:

$$
\mathbb{E}[f(\bar x_K)] - f(x_*) \le \frac{\|x_0-x_*\|^2}{2\sum_{k=0}^K \tau_k} + \frac{\sigma^2 \sum_{k=0}^K \tau_k^2}{2\sum_{k=0}^K \tau_k}.
$$

Pros:

- extremely cheap iteration,
- scales to large datasets,
- natural first method in learning problems.

Cons:

- noisy trajectories,
- final iterate can be poor,
- schedule tuning is important.

Use it when:

- the dataset is large,
- you can sample cheap gradients,
- you want the simplest stochastic baseline.

### AdaGrad-Norm

Update:

$$
\begin{aligned}
g_k &= G(x_k), \\
S_{k+1} &= S_k + \|g_k\|^2, \\
x_{k+1} &= x_k - \frac{\tau}{\sqrt{S_{k+1}}} g_k.
\end{aligned}
$$

Best use case:

- stochastic problems,
- gradient scale poorly known.

Pros:

- automatically damps large gradients,
- almost no tuning beyond a base step.

Cons:

- same scaling for all coordinates,
- can become too conservative after many iterations.

Use it when:

- SGD is unstable because the raw gradient magnitude is hard to estimate.

### AdaGrad (Diagonal)

Update:

$$
\begin{aligned}
g_k &= G(x_k), \\
v_{k+1} &= v_k + g_k \odot g_k, \\
x_{k+1} &= x_k - \tau \frac{g_k}{\sqrt{v_{k+1}}}.
\end{aligned}
$$

The division is coordinate-wise.

Best use case:

- stochastic problems with heterogeneous coordinates,
- sparse or anisotropic gradients.

Pros:

- coordinate-wise adaptation,
- very effective when some coordinates are much noisier or larger than others.

Cons:

- accumulation is irreversible,
- steps may become too small late in the run.

Use it when:

- SGD behaves very differently across coordinates,
- a single global step size is not enough.

### Adam

Update:

$$
\begin{aligned}
g_k &= G(x_k), \\
m_{k+1} &= \beta_1 m_k + (1-\beta_1) g_k, \\
v_{k+1} &= \beta_2 v_k + (1-\beta_2)(g_k \odot g_k), \\
\hat m_{k+1} &= \frac{m_{k+1}}{1-\beta_1^{k+1}}, \\
\hat v_{k+1} &= \frac{v_{k+1}}{1-\beta_2^{k+1}}, \\
x_{k+1} &= x_k - \tau \frac{\hat m_{k+1}}{\sqrt{\hat v_{k+1}} + \delta}.
\end{aligned}
$$

Best use case:

- noisy stochastic optimization,
- nonstationary or poorly scaled gradients,
- practical machine-learning training.

Pros:

- combines momentum and coordinate-wise adaptation,
- usually strong practical behavior with minimal manual scaling.

Cons:

- weaker clean convex theory than GD/CG/Newton,
- hyperparameters matter,
- may converge to a good training point but not necessarily with the cleanest optimization behavior.

Use it when:

- SGD is noisy and slow,
- AdaGrad is too conservative,
- you want a practical stochastic default.

### Projected Gradient Descent

Update:

$$
x_{k+1} = \operatorname{proj}_C\bigl(x_k - \tau \nabla f(x_k)\bigr)
$$

Best use case:

- constrained smooth optimization,
- projection onto $C$ easy to compute.

Theory:

- For closed convex $C$ and convex $L$-smooth $f$, the method converges for standard GD-like step sizes.
- The natural stationarity object is no longer $\nabla f(x_*) = 0$, but the fixed-point condition
  $$
  x_* = \operatorname{proj}_C(x_* - \tau \nabla f(x_*)).
  $$

Pros:

- simple extension of GD,
- directly enforces feasibility.

Cons:

- only attractive when the projection is explicit or cheap,
- if the projection itself is hard, the method becomes unattractive.

Use it when:

- constraints are simple: box, ball, sphere, half-space, affine set, or similar.

### POCS / Alternating Projections

For

$$
C = \bigcap_{i=1}^p C_i,
$$

the update is

$$
x_{k+1} = \operatorname{proj}_{C_p} \circ \cdots \circ \operatorname{proj}_{C_1}(x_k).
$$

Best use case:

- feasibility problems,
- projection onto each $C_i$ easy,
- projection onto the full intersection hard.

Theory:

- For closed convex sets with nonempty intersection, the iterates converge to a feasible point under standard assumptions.

Pros:

- extremely simple,
- only requires local projections,
- natural for constraint satisfaction.

Cons:

- no objective minimization by itself,
- can be slow when sets meet at small angles,
- depends heavily on the geometry of the sets.

Use it when:

- the main goal is feasibility, not optimization.

## What To Test First In Practice

### Smooth Unconstrained Problems

1. Run `GD` if $L$ is known.
2. If $L$ is unknown, run `GD_backtracking`.
3. If GD is too slow because of conditioning, try `GD_accelerated`.
4. If the dimension is moderate and the problem is deterministic, test `bfgs`.
5. If a reliable Hessian is available, test `newton_wolfe`.

### Quadratic Problems

1. If $A$ is SPD, test `CG_quadratic` first.
2. Use `GD_exact` only as a comparison baseline.
3. Use plain GD only to understand conditioning and stability.

### Stochastic / Learning Problems

1. Run `SGD` as the baseline.
2. Compare constant-step and decreasing-step schedules.
3. Always inspect averaged iterates for convex problems.
4. If scaling differs across coordinates, test `adagrad_diag`.
5. If you want a stronger practical optimizer, test `adam`.

### Constrained Problems

1. If projection onto $C$ is explicit, test `proj_GD`.
2. If only individual projections onto $C_i$ are easy, test `POCS`.
3. If neither projection is cheap, another formulation is usually needed.

## Main Failure Modes

- `GD`: wrong step size, especially if $\tau > 1/L$.
- `GD_accelerated`: oscillations or instability if the model is noisy or the step is wrong.
- `newton`: singular or indefinite Hessian, bad initialization.
- `bfgs`: poor behavior if line search is weak or if gradients are noisy.
- `SGD`: variance too large, poor schedule, misleading last iterate.
- `adagrad`: step sizes vanish too early.
- `adam`: good practical loss decrease but weaker theoretical guarantees.
- `proj_GD`: projection easy in theory but numerically expensive in practice.
- `POCS`: slow convergence when the sets are badly positioned.

## Minimal Rule Of Thumb

- Smooth deterministic baseline: `GD` or `GD_backtracking`.
- Smooth deterministic serious solver: `bfgs`.
- Hessian available and dimension moderate: `newton_wolfe`.
- SPD quadratic: `CG_quadratic`.
- Large stochastic finite-sum problem: `SGD` then `adagrad_diag` or `adam`.
- Simple constraints: `proj_GD`.
- Pure feasibility with simple individual projections: `POCS`.
