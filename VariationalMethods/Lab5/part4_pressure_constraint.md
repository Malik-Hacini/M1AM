# Lab 5 - Part 4: why `LU` fails and how to fix it mathematically

We consider the Stokes problem

$$
\begin{cases}
-\nu \Delta u + \nabla p = f & \text{in } \Omega, \\
\nabla \cdot u = 0 & \text{in } \Omega, \\
u = g & \text{on } \partial \Omega.
\end{cases}
$$

The point of part 4 is to understand why replacing the default solver by a direct `LU` factorization may produce a `MATERROR`, and how to remove the difficulty in a mathematically correct way.

## 1. Origin of the problem

The Stokes equations only involve the gradient of the pressure, not the pressure itself.

Indeed, if $(u,p)$ is a solution, then for every constant $c \in \mathbb{R}$,

$$
(u,p+c)
$$

is also a solution, because

$$
\nabla(p+c) = \nabla p.
$$

So the pressure is not uniquely determined: it is defined only up to an additive constant.

This means that the Stokes operator has a nontrivial kernel in the pressure variable.

## 2. How this appears in the weak formulation

The mixed variational formulation is:

$$
\text{Find } (u,p) \in V \times Q \text{ such that}
$$

$$
\nu \int_\Omega \nabla u : \nabla v \, dxdy
-
\int_\Omega p \, \operatorname{div} v \, dxdy
=
\int_\Omega f \cdot v \, dxdy,
\qquad \forall v \in V,
$$

and

$$
\int_\Omega q \, \operatorname{div} u \, dxdy = 0,
\qquad \forall q \in Q,
$$

with

$$
V = (H_0^1(\Omega))^2.
$$

If the pressure is replaced by a constant $c$, then the pressure term in the first equation becomes

$$
-\int_\Omega c \, \operatorname{div} v \, dxdy
=
-c \int_\Omega \operatorname{div} v \, dxdy.
$$

Now apply the divergence theorem:

$$
\int_\Omega \operatorname{div} v \, dxdy = \int_{\partial\Omega} v \cdot n \, ds.
$$

But since $v \in (H_0^1(\Omega))^2$, we have

$$
v = 0 \quad \text{on } \partial\Omega,
$$

hence

$$
\int_{\partial\Omega} v \cdot n \, ds = 0.
$$

Therefore

$$
-\int_\Omega c \, \operatorname{div} v \, dxdy = 0
\qquad \forall v \in V.
$$

So every constant pressure belongs to the kernel of the variational formulation.

## 3. Consequence for the linear system

After discretization, this indeterminacy remains at the algebraic level.

The matrix of the discrete Stokes problem is singular because one pressure mode is free: the constant mode.

Therefore, if one asks for a direct `LU` factorization of this singular matrix, the factorization encounters a zero pivot, and FreeFem reports a `MATERROR`.

So the failure of `LU` is not a bug. It reveals that the linear system is not invertible unless one adds one more condition to fix the pressure level.

## 4. Why post-processing the pressure is not the right fix

If one first solves the unconstrained singular system and then replaces $p$ by

$$
p - \frac{1}{|\Omega|}\int_\Omega p \, dxdy,
$$

this only modifies the pressure after the computation.

It does **not** remove the singularity of the matrix before the solve.

So this does not solve the mathematical issue seen by `LU`: the matrix is still singular at factorization time.

The pressure constraint must be incorporated **inside the problem itself**.

## 5. Exact mathematical fix: impose zero-average pressure

To obtain uniqueness, one imposes

$$
\int_\Omega p \, dxdy = 0.
$$

The natural pressure space is then

$$
L_0^2(\Omega) = \left\{ q \in L^2(\Omega) : \int_\Omega q \, dxdy = 0 \right\}.
$$

This is the correct mathematical way to remove the constant-pressure indeterminacy.

## 6. Lagrange multiplier formulation

A convenient exact way to impose

$$
\int_\Omega p \, dxdy = 0
$$

is to introduce a scalar Lagrange multiplier $\lambda \in \mathbb{R}$.

The augmented mixed formulation becomes:

$$
\text{Find } (u,p,\lambda) \in V \times L^2(\Omega) \times \mathbb{R}
$$

such that, for every

$$
(v,q,\mu) \in V \times L^2(\Omega) \times \mathbb{R},
$$

we have

$$
\nu \int_\Omega \nabla u : \nabla v \, dxdy
-
\int_\Omega p \, \operatorname{div} v \, dxdy
+
\int_\Omega q \, \operatorname{div} u \, dxdy
+
\lambda \int_\Omega q \, dxdy
+
\mu \int_\Omega p \, dxdy
=
\int_\Omega f \cdot v \, dxdy.
$$

Let us explain the two new terms:

$$
\lambda \int_\Omega q \, dxdy
$$

appears in the pressure equation, and

$$
\mu \int_\Omega p \, dxdy
$$

is exactly the constraint equation tested by the scalar test multiplier $\mu$.

Since this equality must hold for every $\mu \in \mathbb{R}$, we obtain

$$
\int_\Omega p \, dxdy = 0.
$$

Thus the constraint is imposed during the solve itself.

## 6.1. Why the term $\lambda \int_\Omega q$ appears

The term

$$
\lambda \int_\Omega q \, dxdy
$$

is not arbitrary. It comes from applying the Lagrange multiplier method to the constraint

$$
\int_\Omega p \, dxdy = 0.
$$

Define the constraint functional

$$
G(p) = \int_\Omega p \, dxdy.
$$

We want to impose

$$
G(p) = 0.
$$

The Lagrange multiplier method says that we introduce a scalar multiplier $\lambda \in \mathbb{R}$ and add the term

$$
\lambda G(p)
$$

to the variational formulation. Here this term is

$$
\lambda \int_\Omega p \, dxdy.
$$

Now the unknowns are

$$
(u,p,\lambda),
$$

and the associated test functions are

$$
(v,q,\mu).
$$

We compute the variations of the added term

$$
\lambda \int_\Omega p \, dxdy.
$$

First, vary the pressure. Replace $p$ by $p + \varepsilon q$. Then

$$
\lambda \int_\Omega (p + \varepsilon q) \, dxdy
=
\lambda \int_\Omega p \, dxdy
+
\varepsilon \lambda \int_\Omega q \, dxdy.
$$

Differentiating with respect to $\varepsilon$ at $\varepsilon = 0$ gives

$$
\lambda \int_\Omega q \, dxdy.
$$

This is exactly the term that appears in the pressure-test equation.

Second, vary the multiplier. Replace $\lambda$ by $\lambda + \varepsilon \mu$. Then

$$
(\lambda + \varepsilon \mu) \int_\Omega p \, dxdy
=
\lambda \int_\Omega p \, dxdy
+
\varepsilon \mu \int_\Omega p \, dxdy.
$$

Differentiating with respect to $\varepsilon$ at $\varepsilon = 0$ gives

$$
\mu \int_\Omega p \, dxdy.
$$

This is the constraint equation. Since the variational equality must hold for every $\mu \in \mathbb{R}$, it forces

$$
\int_\Omega p \, dxdy = 0.
$$

Thus the two terms

$$
\lambda \int_\Omega q \, dxdy
+
\mu \int_\Omega p \, dxdy
$$

come from one single Lagrange multiplier term:

$$
\lambda \int_\Omega p \, dxdy.
$$

The first term is obtained by differentiating with respect to $p$, and the second one by differentiating with respect to $\lambda$.

This also explains why we cannot choose an arbitrary term for $\lambda$. The multiplier must multiply the exact constraint functional. Since the constraint is

$$
G(p) = \int_\Omega p \, dxdy,
$$

the multiplier term must be

$$
\lambda G(p) = \lambda \int_\Omega p \, dxdy.
$$

If instead we had imposed another constraint, such as fixing the pressure at one point,

$$
p(x_0) = 0,
$$

then the constraint functional would have been

$$
G(p) = p(x_0),
$$

and the multiplier term would have been

$$
\lambda p(x_0).
$$

So the term $\lambda \int_\Omega q$ is determined uniquely by the zero-average pressure constraint.

## 7. Why this removes the singularity

Without the extra equation, the pressure can be shifted by any constant.

With the condition

$$
\int_\Omega p \, dxdy = 0,
$$

this is no longer possible. Indeed, if both $p$ and $p+c$ satisfy the zero-average condition, then

$$
\int_\Omega (p+c) \, dxdy = \int_\Omega p \, dxdy + c |\Omega| = 0.
$$

Since also

$$
\int_\Omega p \, dxdy = 0,
$$

we get

$$
c |\Omega| = 0,
$$

hence

$$
c = 0.
$$

So the constant-pressure mode has been eliminated, and the pressure becomes uniquely determined.

This is why the augmented formulation is the correct exact fix.

## 8. Final conclusion

The `MATERROR` obtained with `LU` comes from the fact that the discrete Stokes matrix is singular: the pressure is determined only up to a constant.

The correct mathematical remedy is **not** to modify the pressure after the solve, but to impose a pressure normalization in the formulation itself, for example

$$
\int_\Omega p \, dxdy = 0.
$$

An exact way to do this is to introduce a scalar Lagrange multiplier and solve the augmented saddle-point system.

That is the reason for the extra unknown used in the corrected implementation of `stokes.edp`.
