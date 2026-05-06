#set page(paper: "a4", margin: 2cm)
#set text(size: 11pt, lang: "en")
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 18pt, weight: "bold")[Variational Methods Exam Preparation]

  #v(0.4em)
  Part 2 recap: variational approximation and finite elements
]

#v(1em)

#outline(title: [Contents])

= How To Use This Sheet

This document summarizes what to learn from the Part 2 lecture slides and the matching worksheets.

Primary sources:

- `Lectures/VMAM_slides_part2.pdf`: main Part 2 lecture slides.
- `Lectures/td5-1.pdf`: unisolvent finite element worksheet.
- `Lectures/td6.pdf`: variational approximation and finite element worksheet.
- `Lectures/poly_MVAM.pdf`: global lecture notes, especially Chapter 4.

Priority: learn the theoretical approximation framework first, then learn how it becomes a finite element matrix, then practice unisolvency and small mesh computations.

= Inner Variational Approximation

Sources: `VMAM_slides_part2.pdf`, slides 3-11. Context: `poly_MVAM.pdf`, Chapter 4.1, pages 21-22.

The continuous variational problem is

$
  (F V) quad "Find " u in V " such that " a(u, v) = ell(v) quad forall v in V.
$

The approximate problem is

$
  (F V_h) quad "Find " u_h in V_h " such that " a(u_h, v_h) = ell(v_h) quad forall v_h in V_h.
$

Here $V_h$ is finite-dimensional and $V_h subset V$. This is called an *inner approximation* because the discrete space stays inside the continuous energy space.

What you must know:

- Why $V_h subset V$ matters.
- Why $V_h$ is a Hilbert space: it is finite-dimensional and closed in $V$.
- Why Lax-Milgram applies on $V_h$ with the same continuity and coercivity constants as on $V$.
- Why the discrete solution $u_h$ is unique.

If $(phi_1, dots, phi_N)$ is a basis of $V_h$, then

$
  u_h = sum_(j=1)^N u_h^j phi_j.
$

Testing only with the basis functions gives the linear system

$
  sum_(j=1)^N a(phi_j, phi_i) u_h^j = ell(phi_i), quad i = 1, dots, N.
$

Equivalently,

$
  A U = L,
  quad A_(i j) = a(phi_j, phi_i),
  quad L_i = ell(phi_i).
$

Important detail: the order $A_(i j) = a(phi_j, phi_i)$ follows from testing by $phi_i$ and expanding $u_h$ over $phi_j$.

If $a$ is coercive, then $A$ is positive definite and therefore invertible.

= Cea's Lemma

Sources: `VMAM_slides_part2.pdf`, slides 8-10. Context: `poly_MVAM.pdf`, Theorem 4.1, pages 21-22.

This is the central theorem of Part 2.

$
  norm(u - u_h)_V <= C inf_(v_h in V_h) norm(u - v_h)_V.
$

Interpretation: the finite element error is bounded by the best approximation error in the chosen finite-dimensional space.

The proof idea:

- Since $V_h subset V$, every $w_h in V_h$ is an admissible test function in the continuous problem.
- Subtract the two variational formulations.
- Obtain Galerkin orthogonality:

$
  a(u - u_h, w_h) = 0 quad forall w_h in V_h.
$

- For any $v_h in V_h$, use $w_h = v_h - u_h$.
- Then

$
  a(u - u_h, u - u_h)
  = a(u - u_h, u - v_h).
$

- Use coercivity and continuity:

$
  alpha norm(u - u_h)_V^2
  <= M norm(u - u_h)_V norm(u - v_h)_V.
$

- Divide by $norm(u - u_h)_V$ and take the infimum over $v_h in V_h$.

What to remember for the exam: Cea's lemma turns convergence into a pure approximation question.

= Meaning Of $V_h -> V$

Sources: `VMAM_slides_part2.pdf`, slide 10. Context: `poly_MVAM.pdf`, Theorem 4.2, page 22.

The lecture makes precise what $V_h -> V$ means.

Assume there is a dense subspace $cal(V) subset V$ and operators

$
  r_h: cal(V) -> V_h
$

such that

$
  forall v in cal(V), quad norm(v - r_h v)_V -> 0 " as " h -> 0.
$

Then the discrete solution converges:

$
  norm(u - u_h)_V -> 0.
$

Interpretation:

- $r_h$ is usually an interpolation or projection operator.
- Density lets you approximate any $u in V$ by a nicer function $u_epsilon in cal(V)$.
- The operator $r_h$ then approximates $u_epsilon$ by an element of $V_h$.
- Cea's lemma finishes the convergence proof.

= Hilbert Basis Galerkin Approximation

Sources: `VMAM_slides_part2.pdf`, slides 12-17. Context: `poly_MVAM.pdf`, Chapter 4.2, pages 22-25.

A Hilbert basis of $V$ is an orthonormal countable family $(e_n)_(n >= 1)$ whose linear span is dense in $V$.

One can choose

$
  V_h = "span"(e_1, e_2, dots, e_m), quad h = 1 / m.
$

Then the Galerkin solution $u_m$ converges to $u$.

The important message is not only convergence. The lecture emphasizes that this approach is mostly theoretical.

Advantages:

- It proves existence by reducing infinite-dimensional problems to finite-dimensional linear systems.
- It gives a clean conceptual version of Galerkin approximation.

Disadvantages:

- Matrices are often full.
- Conditioning can be very bad.
- Boundary conditions can be difficult to encode for non-academic domains.

The monomial example in slides 14-16 is important. It converges fast for small $m$, but the condition number is already around $10^8$ for $m = 7$. Lesson: good approximation is not enough; the matrix must also be numerically usable.

= Finite Element Meshes

Sources: `VMAM_slides_part2.pdf`, slides 18-19. Context: `poly_MVAM.pdf`, Chapter 4.5.1, page 32.

Finite element methods choose $V_h$ using localized basis functions built from a mesh of the domain.

A conforming mesh satisfies:

- The union of all elements covers $Omega$.
- Element interiors do not overlap.
- Elements are not flat.
- An internal edge is always the full edge of the neighboring element.

For a triangle $T_l$, define the diameter

$
  h_(T_l) = max_((x_1, x_2) in T_l^2) norm(x_1 - x_2).
$

Define the roundness by the diameter of the largest inscribed ball:

$
  rho_(T_l) = max_(B_r subset T_l) 2 r.
$

The ratio

$
  h_(T_l) / rho_(T_l) >= 1
$

measures flatness. Good meshes avoid large values of this ratio.

Why finite elements give sparse matrices: each basis function is supported only on a small patch of neighboring elements, so most products $a(phi_j, phi_i)$ vanish.

= P1 Lagrange Finite Elements

Sources: `VMAM_slides_part2.pdf`, slides 21-25. Context: `poly_MVAM.pdf`, Chapter 4.5.2, pages 32-33.

The $P_1$ Lagrange finite element space is

$
  V_h = { v_h in C^0(overline(Omega)) : v_h |_(T_l) in P_1, quad forall l = 1, dots, N_t }.
$

In two dimensions,

$
  P_1 = "span"(1, x, y), quad dim P_1 = 3.
$

Key facts:

- $V_h subset H^1(Omega)$ because functions are continuous and piecewise $H^1$.
- A $P_1$ finite element function is completely determined by its values at mesh vertices.
- If the mesh has $N_v$ vertices, then $dim V_h = N_v$.
- The global basis functions are the hat functions $phi_i$ satisfying

$
  phi_i(a_j) = delta_(i j).
$

Every $v_h in V_h$ can be written as

$
  v_h(x) = sum_(i=1)^(N_v) v_h(a_i) phi_i(x).
$

For homogeneous Dirichlet boundary conditions, use

$
  tilde(V)_h = V_h ∩ H^1_0(Omega).
$

Equivalently,

$
  tilde(V)_h = { v_h in V_h : v_h(a_i) = 0 " for all boundary vertices " a_i }.
$

Thus only the basis functions associated with interior vertices remain:

$
  tilde(V)_h = "span" { phi_i : a_i ∉ partial Omega }.
$

= Finite Element Triples And Unisolvency

Sources: `VMAM_slides_part2.pdf`, slides 26-28. Context: `poly_MVAM.pdf`, Chapter 4.4, pages 30-31. Worksheet: `td5-1.pdf`.

A finite element is a triple

$
  (K, P, Sigma),
$

where:

- $K$ is a non-empty compact subset of $RR^d$.
- $P$ is a finite-dimensional vector space of functions on $K$.
- $Sigma = { ell_1, ell_2, dots, ell_m }$ is a set of linear forms on $P$.

The numbers $ell_j(p)$ are the local degrees of freedom.

The finite element is *unisolvent* if

$
  forall (alpha_1, dots, alpha_m) in RR^m,
  exists ! p in P " such that " ell_j(p) = alpha_j
  " for " j = 1, dots, m.
$

Exam method for proving unisolvency:

- First check $"card"(Sigma) = dim P$.
- If the dimensions do not match, the element is not unisolvent.
- If the dimensions match, prove that the only $p in P$ such that $ell_j(p) = 0$ for all $j$ is $p = 0$.
- Equivalently, construct local basis functions $phi_i$ such that

$
  ell_j(phi_i) = delta_(i j).
$

Worksheet `td5-1.pdf` trains exactly this skill.

What to practice there:

- Exercise 1: square with vertex values, center value, and one integral degree of freedom.
- Exercise 2: triangle edge nodes and barycentric coordinates.
- Exercise 3: polynomial space involving $lambda_1$, $lambda_2$, $lambda_3$, and values at vertices, midpoints, and barycenter.

= Barycentric Coordinates

Sources: `poly_MVAM.pdf`, Chapter 4.5.2, pages 32-33. Worksheet: `td5-1.pdf`, Exercises 2 and 3.

For a triangle with vertices $a_1$, $a_2$, $a_3$, the barycentric coordinates of a point $x$ are $(lambda_1, lambda_2, lambda_3)$ such that

$
  x = lambda_1 a_1 + lambda_2 a_2 + lambda_3 a_3,
  quad lambda_1 + lambda_2 + lambda_3 = 1.
$

Important values:

$
  a_1 : (1, 0, 0), quad
  a_2 : (0, 1, 0), quad
  a_3 : (0, 0, 1).
$

At the midpoint $a_(i j)$ of edge $[a_i, a_j]$,

$
  lambda_i = lambda_j = 1 / 2,
  quad lambda_k = 0.
$

For $P_1$ interpolation,

$
  p = sum_(i=1)^3 p(a_i) lambda_i.
$

For $P_2$ interpolation,

$
  p = sum_(i=1)^3 p(a_i) lambda_i (2 lambda_i - 1)
      + 4 sum_(1 <= i < j <= 3) p(a_(i j)) lambda_i lambda_j.
$

This formula is especially useful for constructing basis functions in `td5-1.pdf`.

= Affine Equivalence

Sources: `VMAM_slides_part2.pdf`, slides 29-31. Context: `poly_MVAM.pdf`, Proposition 4.2, page 31.

Finite element calculations are usually performed on a reference element and transported to each physical element.

For triangles, the affine map has the form

$
  F(hat(x)) = B hat(x) + b.
$

If $(hat(K), hat(P), hat(Sigma))$ is the reference element and $(K, P, Sigma)$ is the physical element, the local basis functions transform by

$
  phi_i = hat(phi)_i compose F^(-1).
$

Practical meaning: instead of deriving basis functions and integrals separately on every triangle, compute them on the reference triangle and map them by $F$.

= Higher-Order Elements

Sources: `VMAM_slides_part2.pdf`, slides 32-35.

The $P_k$ Lagrange finite element space is

$
  V_h^k = { v_h in C^0(overline(Omega)) : v_h |_(T_l) in P_k, quad forall l }.
$

Increasing $k$ has three effects:

- The matrix size increases.
- The matrix stays sparse, but has more non-zero terms.
- The approximation is better if the exact solution is regular enough.

The standard estimate is

$
  norm(u - u_h)_(H^1(Omega)) <= C h^k norm(u)_(H^(k+1)(Omega)).
$

Examples to recognize:

- $P_2$ in 1D uses nodes $0$, $1/2$, and $1$.
- $P_2$ in 2D uses vertices and edge midpoints.
- $P_3$ in 2D adds more edge nodes and one interior node.
- $Q_1$ on a square uses $P = "span"(1, x, y, x y)$.
- Hermite elements use function values and derivative values as degrees of freedom, and are useful for fourth-order problems.

= One-Dimensional P1 Assembly

Sources: `poly_MVAM.pdf`, Chapter 4.3.2, pages 25-28. Worksheet: `td6.pdf`, Exercise 1.

For the model problem

$
  -u'' + u = f " on " (0, 1),
  quad u(0) = u(1) = 0,
$

the variational formulation is:

$
  "Find " u in H^1_0(0, 1) " such that "
  integral_0^1 u' v' dif x + integral_0^1 u v dif x
  = integral_0^1 f v dif x
  quad forall v in H^1_0(0, 1).
$

For uniform $P_1$ elements, the basis functions are the hat functions $phi_i$.

The bilinear form is

$
  a(u, v) = integral_0^1 u' v' dif x + integral_0^1 u v dif x.
$

The standard coefficients are

$
  a(phi_i, phi_i) = 2 / h + 2 h / 3,
$

and

$
  a(phi_i, phi_(i+1)) = -1 / h + h / 6.
$

The matrix is tridiagonal because $phi_i$ and $phi_j$ have disjoint supports when $abs(i - j) > 1$.

In `td6.pdf`, Exercise 1, you should be able to:

- Write the variational formulation.
- Identify the Hilbert space $V$.
- Define the discrete space $V_h$.
- Define the hat basis functions.
- Write the discrete variational problem.
- Write the final linear system with explicit coefficients.
- Explain how to treat a non-homogeneous Dirichlet condition $u(0) = b$.

= Two-Dimensional P1 Computations On Small Meshes

Sources: `td6.pdf`, Exercises 2 and 3. Context: `VMAM_slides_part2.pdf`, slides 21-25, and `poly_MVAM.pdf`, Chapter 4.5.

For homogeneous Dirichlet boundary conditions, only interior vertices give degrees of freedom.

In `td6.pdf`, Exercise 2, the square is divided into four triangles and there is one interior point $E$. Therefore the discrete space has dimension $1$.

Let $w$ be the unique basis function satisfying

$
  w(E) = 1,
  quad w = 0 " at all boundary vertices."
$

Then

$
  u_h = U w.
$

The linear system is a single equation

$
  a U = b,
$

where

$
  a = integral_Omega |nabla w|^2 dif x dif y,
  quad b = integral_Omega w dif x dif y.
$

The worksheet result is

$
  U = 1 / 12.
$

For `td6.pdf`, Exercise 3, the mesh is a long rectangle subdivided into repeated triangular cells. The expected skills are:

- Count the interior degrees of freedom.
- Define the $P_1$ approximation space.
- Give the hat-function basis explicitly by nodes.
- Use symmetry/repetition of the mesh to solve the discrete problem efficiently.

= Exam Priority Checklist

+ Understand the passage from $(F V)$ to $(F V_h)$.
+ Derive the matrix system $A U = L$ from a basis of $V_h$.
+ Prove Cea's lemma.
+ Explain the convergence criterion using $r_h: cal(V) -> V_h$.
+ Define $P_1$ finite elements on a triangulation.
+ Prove $dim V_h = N_v$ for $P_1$ elements.
+ Explain how homogeneous Dirichlet conditions remove boundary basis functions.
+ Define a finite element triple $(K, P, Sigma)$.
+ Test unisolvency by dimension count and zero-kernel argument.
+ Construct local basis functions with barycentric coordinates.
+ Explain affine equivalence and reference elements.
+ Compute simple 1D $P_1$ stiffness and mass entries.
+ Compute simple 2D $P_1$ examples on tiny meshes.

= Likely Exam Questions

- State and prove Cea's lemma.
- Explain why the discrete variational problem has a unique solution.
- Starting from a basis of $V_h$, derive the matrix system.
- Define the $P_1$ finite element space and prove that its dimension is the number of mesh vertices.
- Explain why $V_h subset H^1(Omega)$.
- Explain how homogeneous Dirichlet boundary conditions are imposed in finite elements.
- Decide whether a finite element is unisolvent.
- Build basis functions using barycentric coordinates.
- Compute a small stiffness matrix by hand.
- Explain why finite element matrices are sparse.
- Compare Hilbert-basis Galerkin methods with finite element methods.

= Minimal Proof Templates To Memorize

== Cea's Lemma Template

Start from Galerkin orthogonality:

$
  a(u - u_h, w_h) = 0 quad forall w_h in V_h.
$

For arbitrary $v_h in V_h$, choose $w_h = v_h - u_h$. Then

$
  a(u - u_h, u - u_h) = a(u - u_h, u - v_h).
$

By coercivity and continuity,

$
  alpha norm(u - u_h)_V^2
  <= M norm(u - u_h)_V norm(u - v_h)_V.
$

Conclude

$
  norm(u - u_h)_V <= (M / alpha) norm(u - v_h)_V.
$

Then take the infimum over $v_h in V_h$.

== Unisolvency Template

To prove that $(K, P, Sigma)$ is unisolvent:

+ Check $"card"(Sigma) = dim P$.
+ Let $p in P$ satisfy $ell(p) = 0$ for every $ell in Sigma$.
+ Use the conditions to force all coefficients of $p$ to vanish.
+ Conclude $p = 0$.
+ Therefore the map $p -> (ell_1(p), dots, ell_m(p))$ is injective between spaces of the same finite dimension, hence bijective.

To prove it is not unisolvent, find one non-zero $p in P$ such that all degrees of freedom vanish.

== Homogeneous Dirichlet Finite Element Template

Start from

$
  V_h = { v_h in C^0(overline(Omega)) : v_h |_(T) in P_1 }.
$

For homogeneous Dirichlet conditions, use

$
  V_(h,0) = V_h ∩ H^1_0(Omega).
$

Since $P_1$ functions are determined by vertex values, impose

$
  v_h(a_i) = 0
$

for every boundary vertex $a_i$. The remaining unknowns are the values at interior vertices.
