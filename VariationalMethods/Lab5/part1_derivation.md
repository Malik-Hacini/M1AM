# Lab 5 - Part 1: detailed derivation of the mixed variational formulation

We consider the stationary Stokes problem with homogeneous Dirichlet boundary condition:

$$
\begin{cases}
-\nu \Delta u + \nabla p = f & \text{in } \Omega, \\
\nabla \cdot u = 0 & \text{in } \Omega, \\
u = 0 & \text{on } \partial \Omega.
\end{cases}
$$

Here

$$
u = \begin{pmatrix} u_1 \\ u_2 \end{pmatrix},
\qquad
p : \Omega \to \mathbb{R},
\qquad
f = \begin{pmatrix} f_1 \\ f_2 \end{pmatrix}.
$$

The viscosity satisfies $\nu > 0$.

## 1. Pressure normalization

If $(u,p)$ is a solution, then for every constant $c \in \mathbb{R}$, the pair $(u,p+c)$ is also a solution, because

$$
\nabla(p+c) = \nabla p.
$$

So the pressure is only determined up to an additive constant. To remove this indeterminacy, we impose the zero-average condition

$$
\int_\Omega p \, dxdy = 0.
$$

Therefore the pressure space will be

$$
L_0^2(\Omega) = \left\{ q \in L^2(\Omega) : \int_\Omega q \, dxdy = 0 \right\}.
$$

## 2. Strong form written componentwise

The vector equation

$$
-\nu \Delta u + \nabla p = f
$$

is equivalent to

$$
\begin{cases}
-\nu \Delta u_1 + \partial_x p = f_1, \\
-\nu \Delta u_2 + \partial_y p = f_2.
\end{cases}
$$

The incompressibility condition is

$$
\partial_x u_1 + \partial_y u_2 = 0.
$$

## 3. Choice of the test spaces

Since the velocity satisfies the homogeneous Dirichlet condition $u=0$ on $\partial \Omega$, the natural velocity space is

$$
V = \bigl(H_0^1(\Omega)\bigr)^2.
$$

So a velocity test function is

$$
v = \begin{pmatrix} v_1 \\ v_2 \end{pmatrix} \in V,
$$

that is,

$$
v_1, v_2 \in H_0^1(\Omega).
$$

In particular,

$$
v = 0 \quad \text{on } \partial \Omega.
$$

For the pressure, because of the normalization constraint, the natural space is

$$
Q = L_0^2(\Omega).
$$

So the pressure test function is taken in

$$
q \in Q.
$$

## 4. First momentum equation

We start from

$$
-\nu \Delta u_1 + \partial_x p = f_1.
$$

Multiply by $v_1$ and integrate over $\Omega$:

$$
\int_\Omega \left(-\nu \Delta u_1 + \partial_x p\right) v_1 \, dxdy
=
\int_\Omega f_1 v_1 \, dxdy.
$$

We now integrate by parts the two terms on the left-hand side.

For the Laplacian term,

$$
-\nu \int_\Omega \Delta u_1 \, v_1 \, dxdy
=
\nu \int_\Omega \nabla u_1 \cdot \nabla v_1 \, dxdy
-
\nu \int_{\partial\Omega} \partial_n u_1 \, v_1 \, ds.
$$

Since $v_1 = 0$ on $\partial\Omega$, the boundary term vanishes. Hence

$$
-\nu \int_\Omega \Delta u_1 \, v_1 \, dxdy
=
\nu \int_\Omega \nabla u_1 \cdot \nabla v_1 \, dxdy.
$$

For the pressure term,

$$
\int_\Omega \partial_x p \, v_1 \, dxdy
=
-\int_\Omega p \, \partial_x v_1 \, dxdy
+
\int_{\partial\Omega} p \, v_1 n_1 \, ds.
$$

Again, since $v_1 = 0$ on $\partial\Omega$, the boundary term vanishes, and we get

$$
\int_\Omega \partial_x p \, v_1 \, dxdy
=
-\int_\Omega p \, \partial_x v_1 \, dxdy.
$$

Therefore the first weak equation becomes

$$
\nu \int_\Omega \nabla u_1 \cdot \nabla v_1 \, dxdy
-
\int_\Omega p \, \partial_x v_1 \, dxdy
=
\int_\Omega f_1 v_1 \, dxdy.
$$

## 5. Second momentum equation

We now start from

$$
-\nu \Delta u_2 + \partial_y p = f_2.
$$

Multiplying by $v_2$ and integrating over $\Omega$ gives

$$
\int_\Omega \left(-\nu \Delta u_2 + \partial_y p\right) v_2 \, dxdy
=
\int_\Omega f_2 v_2 \, dxdy.
$$

Exactly as for the first equation, after integration by parts and using $v_2=0$ on $\partial\Omega$, we obtain

$$
\nu \int_\Omega \nabla u_2 \cdot \nabla v_2 \, dxdy
-
\int_\Omega p \, \partial_y v_2 \, dxdy
=
\int_\Omega f_2 v_2 \, dxdy.
$$

## 6. Incompressibility equation

The third equation is

$$
\nabla \cdot u = 0.
$$

Multiply it by a pressure test function $q \in Q$ and integrate over $\Omega$:

$$
\int_\Omega q \, \nabla \cdot u \, dxdy = 0.
$$

Since

$$
\nabla \cdot u = \partial_x u_1 + \partial_y u_2,
$$

this is

$$
\int_\Omega q \left(\partial_x u_1 + \partial_y u_2\right) dxdy = 0.
$$

## 7. Summation of the momentum equations

Adding the two momentum equations, we obtain

$$
\nu \int_\Omega \left( \nabla u_1 \cdot \nabla v_1 + \nabla u_2 \cdot \nabla v_2 \right) dxdy
-
\int_\Omega p \left(\partial_x v_1 + \partial_y v_2\right) dxdy
=
\int_\Omega \left(f_1 v_1 + f_2 v_2\right) dxdy.
$$

Now we use the notation

$$
\nabla u : \nabla v = \nabla u_1 \cdot \nabla v_1 + \nabla u_2 \cdot \nabla v_2,
$$

and also

$$
\nabla \cdot v = \partial_x v_1 + \partial_y v_2,
\qquad
f \cdot v = f_1 v_1 + f_2 v_2.
$$

Hence the two momentum equations can be written in compact form as

$$
\nu \int_\Omega \nabla u : \nabla v \, dxdy
-
\int_\Omega p \, \nabla \cdot v \, dxdy
=
\int_\Omega f \cdot v \, dxdy,
\qquad \forall v \in V.
$$

The incompressibility equation becomes

$$
\int_\Omega q \, \nabla \cdot u \, dxdy = 0,
\qquad \forall q \in Q.
$$

## 8. Final mixed variational formulation

We conclude that the mixed variational formulation is:

$$
\text{Find } (u,p) \in V \times Q \text{ such that}
$$

$$
\nu \int_\Omega \nabla u : \nabla v \, dxdy
-
\int_\Omega p \, \nabla \cdot v \, dxdy
=
\int_\Omega f \cdot v \, dxdy,
\qquad \forall v \in V,
$$

and

$$
\int_\Omega q \, \nabla \cdot u \, dxdy = 0,
\qquad \forall q \in Q,
$$

with

$$
V = \bigl(H_0^1(\Omega)\bigr)^2,
\qquad
Q = L_0^2(\Omega).
$$

Equivalently, by combining the two equations, one may write:

$$
\text{Find } (u,p) \in V \times Q \text{ such that}
$$

$$
\nu \int_\Omega \nabla u : \nabla v \, dxdy
-
\int_\Omega p \, \nabla \cdot v \, dxdy
+
\int_\Omega q \, \nabla \cdot u \, dxdy
=
\int_\Omega f \cdot v \, dxdy,
$$

for every

$$
(v,q) \in V \times Q.
$$

This is the standard mixed weak formulation of the Stokes problem with homogeneous Dirichlet boundary conditions and zero-average pressure.
