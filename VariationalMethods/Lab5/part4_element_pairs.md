# Lab 5 - Part 4: which finite element pairs are satisfactory?

The second question of Part 4 asks:

> Impose $g = (x^2,0)$ on the upper border and use a structured mesh. Try the finite element pairs $P1/P1$, $P1/P0$ and $P1b/P1$. Which pairs are satisfactory?

The goal is to determine which velocity-pressure pairs are suitable for the mixed discretization of the Stokes problem.

## 1. The mathematical criterion: the inf-sup condition

For the Stokes problem, the mixed formulation is not well posed for an arbitrary pair of discrete spaces.

If $V_h$ is the discrete velocity space and $Q_h$ the discrete pressure space, the pair $(V_h,Q_h)$ must satisfy the discrete inf-sup condition (also called the Ladyzhenskaya-Babuska-Brezzi condition):

$$
\inf_{q_h \in Q_h \setminus \{0\}}
\sup_{v_h \in V_h \setminus \{0\}}
\frac{\int_\Omega q_h \, \operatorname{div} v_h \, dxdy}
{\|v_h\|_{H^1(\Omega)^2} \, \|q_h\|_{L^2(\Omega)}}
\ge \beta > 0,
$$

with a constant $\beta$ independent of the mesh size $h$.

This condition means that the velocity space must be rich enough to control all admissible discrete pressure modes.

If this condition fails, the usual consequences are:

1. nonphysical pressure oscillations,
2. poor conditioning or instability of the linear system,
3. velocity-pressure approximations that do not converge correctly.

So a pair is called **satisfactory** if it satisfies this stability requirement and gives physically meaningful numerical solutions.

## 2. Why a structured mesh matters here

The worksheet asks specifically for a structured mesh and the boundary condition

$$
g = (x^2,0)
$$

on the top boundary.

On structured meshes, unstable pressure modes are often easier to observe, especially alternating or checkerboard-type oscillations. So this is a good test configuration for detecting whether a pair is stable or not.

## 3. Numerical exploration performed

To answer the question, I ran a comparison on a structured mesh for the three requested pairs:

1. $P1/P1$
2. $P1/P0$
3. $P1b/P1$

I also computed a finer $P2/P1$ Taylor-Hood solution as a reference.

The pressure was not post-processed afterward: the zero-average condition was imposed directly in the linear system through a scalar Lagrange multiplier.

The obtained diagnostics were:

$$
\text{Reference } P2/P1: \quad \int_\Omega p_h \approx -3.1 \times 10^{-16}
$$

$$
P1/P1: \quad \int_\Omega p_h \approx -9.3 \times 10^9,
\qquad
\|u_h-u_{ref}\|_{L^2} \approx 1.21 \times 10^{-1},
\qquad
\|p_h-p_{ref}\|_{L^2} \approx 1.20 \times 10^{27}
$$

$$
P1/P0: \quad \int_\Omega p_h \approx 2.34 \times 10^{41},
\qquad
\|u_h-u_{ref}\|_{L^2} \approx 1.01 \times 10^{29},
\qquad
\|p_h-p_{ref}\|_{L^2} \approx 6.67 \times 10^{58}
$$

$$
P1b/P1: \quad \int_\Omega p_h \approx -1.1 \times 10^{-16},
\qquad
\|u_h-u_{ref}\|_{L^2} \approx 4.43 \times 10^{-2},
\qquad
\|p_h-p_{ref}\|_{L^2} \approx 2.61
$$

These computations clearly separate the stable and unstable pairs.

## 4. Analysis of each pair

## 4.1. Pair $P1/P1$

Here both the velocity and the pressure are approximated with continuous piecewise linear functions.

This pair is a classical example of an **unstable equal-order discretization** for the Stokes problem.

The reason is that the discrete velocity space is not sufficiently rich to control all discrete pressure modes. In other words, the pair does not satisfy the discrete inf-sup condition.

As a consequence, spurious pressure modes appear. On structured meshes, these oscillatory modes are especially visible. Numerically, this is reflected by the huge pressure error and the loss of a meaningful pressure field.

Therefore:

$$
P1/P1 \quad \text{is not satisfactory.}
$$

## 4.2. Pair $P1/P0$

Here the velocity is continuous piecewise linear, while the pressure is piecewise constant.

Although this choice may look natural because

$$
\operatorname{div}(P1) \subset P0
$$

elementwise, this pair is still not stable on the standard structured triangulations used here.

The problem is again that the discrete velocity space does not control all pressure modes. On structured meshes, there remain spurious piecewise constant pressure patterns that are invisible to the discrete divergence operator.

The numerical results are even worse than for $P1/P1$: the errors become catastrophic, which is the signature of a very unstable discretization.

Therefore:

$$
P1/P0 \quad \text{is not satisfactory on this structured mesh.}
$$

## 4.3. Pair $P1b/P1$

This is the **mini-element**:

1. the velocity is approximated by $P1b$, that is, continuous piecewise linear functions enriched with an interior bubble on each triangle,
2. the pressure is approximated by continuous piecewise linear functions $P1$.

The bubble enrichment adds precisely the missing local velocity degrees of freedom needed to recover stability.

This pair is known to satisfy the discrete inf-sup condition for triangular meshes. Consequently:

1. the pressure does not develop spurious oscillations,
2. the approximation remains stable,
3. the numerical solution is physically meaningful.

This is exactly what is observed in the computations above: the zero-average constraint is correctly respected and the errors remain reasonable.

Therefore:

$$
P1b/P1 \quad \text{is satisfactory.}
$$

## 5. Final answer

Among the three pairs proposed in the worksheet:

$$
P1/P1, \qquad P1/P0, \qquad P1b/P1,
$$

the only satisfactory pair is

$$
\boxed{P1b/P1.}
$$

The two other pairs,

$$
P1/P1 \quad \text{and} \quad P1/P0,
$$

are not satisfactory in this setting because they do not satisfy the discrete inf-sup condition on the structured mesh, which leads to unstable and oscillatory pressure approximations.

## 6. Additional remark

This also explains why the Taylor-Hood pair used in Part 2,

$$
P2/P1,
$$

works well: it is another classical stable pair for the Stokes equations.
