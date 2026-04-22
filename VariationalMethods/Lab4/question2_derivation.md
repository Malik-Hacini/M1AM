# Lab 4 - Question 2: detailed derivation of the variational formulation

We consider the boundary value problem

$$
\begin{cases}
-\operatorname{div}\sigma(u) = f & \text{in } \Omega, \\
u = 0 & \text{on } \Gamma_4, \\
\sigma(u)n = g & \text{on } \Gamma \setminus \Gamma_4,
\end{cases}
$$

where

$$
u = \begin{pmatrix} u_1 \\ u_2 \end{pmatrix},
\qquad
f = \begin{pmatrix} f_1 \\ f_2 \end{pmatrix},
\qquad
g = \begin{pmatrix} g_1 \\ g_2 \end{pmatrix}.
$$

The stress tensor is given by Hooke's law:

$$
\sigma(u) = 2\mu e(u) + \lambda \, \operatorname{tr}(e(u)) I_2,
$$

with

$$
e(u) = \frac12 \left(\nabla u + \nabla u^T\right).
$$

From Question 1, we know that

$$
\operatorname{tr}(e(u)) = \operatorname{div}u,
$$

so

$$
\sigma(u) =
\begin{pmatrix}
2\mu \dfrac{\partial u_1}{\partial x} + \lambda \, \operatorname{div}u
&
\mu \left(\dfrac{\partial u_1}{\partial y} + \dfrac{\partial u_2}{\partial x}\right) \\
\mu \left(\dfrac{\partial u_1}{\partial y} + \dfrac{\partial u_2}{\partial x}\right)
&
2\mu \dfrac{\partial u_2}{\partial y} + \lambda \, \operatorname{div}u
\end{pmatrix}.
$$

## 1. Strong form written componentwise

The equation

$$
-\operatorname{div}\sigma(u) = f
$$

means

$$
\begin{cases}
-\partial_x\sigma_{11}(u) - \partial_y\sigma_{12}(u) = f_1, \\
-\partial_x\sigma_{21}(u) - \partial_y\sigma_{22}(u) = f_2.
\end{cases}
$$

We first derive the weak formulation formally for a smooth solution, and then we identify the correct Sobolev space.

## 2. Choice of the test space

The Dirichlet condition is imposed on $\Gamma_4$, so the scalar test space is

$$
V = \{ w \in H^1(\Omega) : w = 0 \text{ on } \Gamma_4 \}.
$$

The unknown is vector-valued, so the natural space is

$$
V^2 = V \times V.
$$

We therefore take a test function

$$
v = \begin{pmatrix} v_1 \\ v_2 \end{pmatrix} \in V^2.
$$

Hence

$$
v_1 = 0 \text{ on } \Gamma_4,
\qquad
v_2 = 0 \text{ on } \Gamma_4.
$$

## 3. Derivation of the first weak equation

We start from the first scalar equation

$$
-\partial_x\sigma_{11}(u) - \partial_y\sigma_{12}(u) = f_1.
$$

Multiply by $v_1 \in V$ and integrate over $\Omega$:

$$
\int_\Omega \left(-\partial_x\sigma_{11}(u) - \partial_y\sigma_{12}(u)\right) v_1 \, dxdy
=
\int_\Omega f_1 v_1 \, dxdy.
$$

We integrate by parts term by term.

For the first term,

$$
-\int_\Omega \partial_x\sigma_{11}(u) \, v_1 \, dxdy
=
\int_\Omega \sigma_{11}(u) \, \partial_x v_1 \, dxdy
-
\int_\Gamma \sigma_{11}(u) v_1 n_1 \, ds.
$$

For the second term,

$$
-\int_\Omega \partial_y\sigma_{12}(u) \, v_1 \, dxdy
=
\int_\Omega \sigma_{12}(u) \, \partial_y v_1 \, dxdy
-
\int_\Gamma \sigma_{12}(u) v_1 n_2 \, ds.
$$

Adding these two equalities gives

$$
\int_\Omega \left(\sigma_{11}(u)\partial_x v_1 + \sigma_{12}(u)\partial_y v_1\right) dxdy
-
\int_\Gamma \left(\sigma_{11}(u)n_1 + \sigma_{12}(u)n_2\right) v_1 \, ds
=
\int_\Omega f_1 v_1 \, dxdy.
$$

Now,

$$
(\sigma(u)n)_1 = \sigma_{11}(u)n_1 + \sigma_{12}(u)n_2,
$$

so this becomes

$$
\int_\Omega \left(\sigma_{11}(u)\partial_x v_1 + \sigma_{12}(u)\partial_y v_1\right) dxdy
-
\int_\Gamma (\sigma(u)n)_1 v_1 \, ds
=
\int_\Omega f_1 v_1 \, dxdy.
$$

We split the boundary integral into the Dirichlet part and the Neumann part:

$$
\int_\Gamma (\sigma(u)n)_1 v_1 \, ds
=
\int_{\Gamma_4} (\sigma(u)n)_1 v_1 \, ds
+
\int_{\Gamma \setminus \Gamma_4} (\sigma(u)n)_1 v_1 \, ds.
$$

On $\Gamma_4$, we have $v_1 = 0$, so the first term vanishes. On $\Gamma \setminus \Gamma_4$, we use the boundary condition

$$
\sigma(u)n = g,
$$

hence

$$
(\sigma(u)n)_1 = g_1.
$$

Therefore,

$$
\int_\Omega \left(\sigma_{11}(u)\partial_x v_1 + \sigma_{12}(u)\partial_y v_1\right) dxdy
=
\int_\Omega f_1 v_1 \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g_1 v_1 \, ds.
$$

We define

$$
a_1(u,v_1)
=
\int_\Omega \left(\sigma_{11}(u)\partial_x v_1 + \sigma_{12}(u)\partial_y v_1\right) dxdy,
$$

$$
l_1(v_1)
=
\int_\Omega f_1 v_1 \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g_1 v_1 \, ds.
$$

So the first weak equation is

$$
a_1(u,v_1) = l_1(v_1), \qquad \forall v_1 \in V.
$$

## 4. Derivation of the second weak equation

We now consider the second scalar equation

$$
-\partial_x\sigma_{21}(u) - \partial_y\sigma_{22}(u) = f_2.
$$

At this stage, there is a complete symmetry of roles between:

$$
\sigma_{1i} \longleftrightarrow \sigma_{2i},
\qquad
v_1 \longleftrightarrow v_2,
\qquad
f_1 \longleftrightarrow f_2,
\qquad
g_1 \longleftrightarrow g_2.
$$

Therefore, by exactly the same reasoning as in Step 3, we obtain immediately

$$
\int_\Omega \left(\sigma_{21}(u)\partial_x v_2 + \sigma_{22}(u)\partial_y v_2\right) dxdy
=
\int_\Omega f_2 v_2 \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g_2 v_2 \, ds.
$$

We define

$$
a_2(u,v_2)
=
\int_\Omega \left(\sigma_{21}(u)\partial_x v_2 + \sigma_{22}(u)\partial_y v_2\right) dxdy,
$$

$$
l_2(v_2)
=
\int_\Omega f_2 v_2 \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g_2 v_2 \, ds.
$$

Hence the second weak equation is

$$
a_2(u,v_2) = l_2(v_2), \qquad \forall v_2 \in V.
$$

## 5. Summation of the two equations

The formulation used in the worksheet for FreeFem++ is the scalar form obtained by summing the two componentwise equations.

Adding the two equalities yields

$$
\int_\Omega \left(
\sigma_{11}(u)\partial_x v_1
+
\sigma_{12}(u)\partial_y v_1
+
\sigma_{21}(u)\partial_x v_2
+
\sigma_{22}(u)\partial_y v_2
\right) dxdy
=
\int_\Omega f \cdot v \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g \cdot v \, ds.
$$

We define

$$
\widetilde a(u,v) = a_1(u,v_1) + a_2(u,v_2),
$$

$$
\widetilde l(v) = l_1(v_1) + l_2(v_2).
$$

Thus the variational formulation already has the form

$$
\widetilde a(u,v) = \widetilde l(v), \qquad \forall v \in V^2.
$$

## 6. Replace the stress components by their expressions

Using Hooke's law, we have

$$
\sigma_{11}(u) = 2\mu \frac{\partial u_1}{\partial x} + \lambda \, \operatorname{div}u,
$$

$$
\sigma_{12}(u) = \sigma_{21}(u) = \mu \left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right),
$$

$$
\sigma_{22}(u) = 2\mu \frac{\partial u_2}{\partial y} + \lambda \, \operatorname{div}u.
$$

Substituting into the bilinear form gives

$$
\widetilde a(u,v)
=
\int_\Omega \Bigg[
\left(2\mu \frac{\partial u_1}{\partial x} + \lambda \, \operatorname{div}u\right) \frac{\partial v_1}{\partial x}
+
\mu \left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right) \frac{\partial v_1}{\partial y}
$$

$$
\qquad
+
\mu \left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right) \frac{\partial v_2}{\partial x}
+
\left(2\mu \frac{\partial u_2}{\partial y} + \lambda \, \operatorname{div}u\right) \frac{\partial v_2}{\partial y}
\Bigg] dxdy.
$$

Grouping the terms gives

$$
\widetilde a(u,v)
=
\int_\Omega \Bigg[
2\mu \frac{\partial u_1}{\partial x} \frac{\partial v_1}{\partial x}
+
2\mu \frac{\partial u_2}{\partial y} \frac{\partial v_2}{\partial y}
+
\mu \left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right)
\left(\frac{\partial v_1}{\partial y} + \frac{\partial v_2}{\partial x}\right)
+
\lambda \, \operatorname{div}u \, \operatorname{div}v
\Bigg] dxdy,
$$

where

$$
\operatorname{div}u = \frac{\partial u_1}{\partial x} + \frac{\partial u_2}{\partial y},
\qquad
\operatorname{div}v = \frac{\partial v_1}{\partial x} + \frac{\partial v_2}{\partial y}.
$$

The linear form is simply

$$
\widetilde l(v)
=
\int_\Omega f \cdot v \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g \cdot v \, ds.
$$

## 7. Compact tensor form

The previous expression can be written more compactly using the strain tensor.

Recall that

$$
e(u) = \frac12(\nabla u + \nabla u^T),
\qquad
e(v) = \frac12(\nabla v + \nabla v^T).
$$

Since $\sigma(u)$ is symmetric, we have

$$
\sigma(u) : \nabla v = \sigma(u) : e(v).
$$

Therefore,

$$
\widetilde a(u,v) = \int_\Omega \sigma(u) : e(v) \, dxdy.
$$

Now use Hooke's law:

$$
\sigma(u) = 2\mu e(u) + \lambda \, \operatorname{tr}(e(u)) I_2.
$$

Hence

$$
\sigma(u):e(v)
=
2\mu \, e(u):e(v)
+
\lambda \, \operatorname{tr}(e(u)) \operatorname{tr}(e(v)).
$$

Since

$$
\operatorname{tr}(e(u)) = \operatorname{div}u,
\qquad
\operatorname{tr}(e(v)) = \operatorname{div}v,
$$

we obtain

$$
\sigma(u):e(v) = 2\mu \, e(u):e(v) + \lambda \, \operatorname{div}u \, \operatorname{div}v.
$$

Thus

$$
\widetilde a(u,v)
=
\int_\Omega \left(2\mu \, e(u):e(v) + \lambda \, \operatorname{div}u \, \operatorname{div}v\right) dxdy.
$$

## 8. Explicit expanded form

We have

$$
e(u) =
\begin{pmatrix}
\dfrac{\partial u_1}{\partial x}
&
\dfrac12\left(\dfrac{\partial u_1}{\partial y} + \dfrac{\partial u_2}{\partial x}\right) \\
\dfrac12\left(\dfrac{\partial u_1}{\partial y} + \dfrac{\partial u_2}{\partial x}\right)
&
\dfrac{\partial u_2}{\partial y}
\end{pmatrix},
$$

and similarly for $e(v)$. Therefore,

$$
e(u):e(v)
=
\frac{\partial u_1}{\partial x} \frac{\partial v_1}{\partial x}
+
\frac{\partial u_2}{\partial y} \frac{\partial v_2}{\partial y}
+
\frac12
\left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right)
\left(\frac{\partial v_1}{\partial y} + \frac{\partial v_2}{\partial x}\right).
$$

Multiplying by $2\mu$ gives

$$
2\mu \, e(u):e(v)
=
2\mu \frac{\partial u_1}{\partial x} \frac{\partial v_1}{\partial x}
+
2\mu \frac{\partial u_2}{\partial y} \frac{\partial v_2}{\partial y}
+
\mu
\left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right)
\left(\frac{\partial v_1}{\partial y} + \frac{\partial v_2}{\partial x}\right).
$$

So the bilinear form is exactly

$$
\widetilde a(u,v)
=
2\mu \int_\Omega
\left(
\frac{\partial u_1}{\partial x} \frac{\partial v_1}{\partial x}
+
\frac{\partial u_2}{\partial y} \frac{\partial v_2}{\partial y}
\right) dxdy
+
\mu \int_\Omega
\left(\frac{\partial u_1}{\partial y} + \frac{\partial u_2}{\partial x}\right)
\left(\frac{\partial v_1}{\partial y} + \frac{\partial v_2}{\partial x}\right) dxdy
+
\lambda \int_\Omega \operatorname{div}u \, \operatorname{div}v \, dxdy.
$$

## 9. Final variational formulation

We have proved that the weak formulation associated with problem (3) is:

$$
\text{Find } u \in V^2 \text{ such that } \widetilde a(u,v) = \widetilde l(v), \qquad \forall v \in V^2,
$$

with

$$
V = \{ w \in H^1(\Omega) : w = 0 \text{ on } \Gamma_4 \},
$$

$$
\widetilde a(u,v)
=
\int_\Omega \left(2\mu \, e(u):e(v) + \lambda \, \operatorname{div}u \, \operatorname{div}v\right) dxdy,
$$

$$
\widetilde l(v)
=
\int_\Omega f \cdot v \, dxdy
+
\int_{\Gamma \setminus \Gamma_4} g \cdot v \, ds.
$$

The Dirichlet condition on $\Gamma_4$ is incorporated into the space $V^2$, and the Neumann condition on $\Gamma \setminus \Gamma_4$ appears naturally in the right-hand side.
