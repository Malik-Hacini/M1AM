#set page(paper: "a4", margin: 2cm)
#set text(size: 11pt, lang: "en")
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 17pt, weight: "bold")[Barycentric Coordinates]

  #v(0.3em)
  #text(size: 13pt)[How to express finite element basis functions]
]

#v(1em)

= Main Idea

Barycentric coordinates are another coordinate system on a triangle.

Let $K$ be a triangle with vertices $a_1$, $a_2$, $a_3$. For every point $x in K$, there exist unique numbers $lambda_1(x)$, $lambda_2(x)$, $lambda_3(x)$ such that

$
  x = lambda_1(x) a_1 + lambda_2(x) a_2 + lambda_3(x) a_3,
  quad
  lambda_1(x) + lambda_2(x) + lambda_3(x) = 1.
$

The functions $lambda_1$, $lambda_2$, $lambda_3$ are called the barycentric coordinate functions.

They are affine functions on the triangle.

= Important Values

At the vertices, the barycentric coordinates are

$
  a_1 : (1, 0, 0),
  quad
  a_2 : (0, 1, 0),
  quad
  a_3 : (0, 0, 1).
$

At the midpoint $a_(i j)$ of the edge $[a_i, a_j]$, we have

$
  lambda_i = 1/2,
  quad
  lambda_j = 1/2,
  quad
  lambda_k = 0,
$

where ${i, j, k} = {1, 2, 3}$.

For example:

$
  a_(12) : (1/2, 1/2, 0),
  quad
  a_(13) : (1/2, 0, 1/2),
  quad
  a_(23) : (0, 1/2, 1/2).
$

= What It Means To Express $phi$ In Barycentric Coordinates

The barycentric coordinates $lambda_1$, $lambda_2$, $lambda_3$ are functions of $x$.

So when we write

$
  phi = lambda_1 + lambda_2 - lambda_3,
$

we mean

$
  phi(x) = lambda_1(x) + lambda_2(x) - lambda_3(x).
$

Thus we are not replacing a function by three numbers. We are writing the function using the coordinate functions $lambda_i$.

= Example On The Reference Triangle

Take the reference triangle

$
  a_1 = (0, 0),
  quad
  a_2 = (1, 0),
  quad
  a_3 = (0, 1).
$

For a point $x = (X, Y)$, the barycentric coordinates are

$
  lambda_1(X, Y) = 1 - X - Y,
  quad
  lambda_2(X, Y) = X,
  quad
  lambda_3(X, Y) = Y.
$

Therefore, if

$
  phi = lambda_1 + lambda_2 - lambda_3,
$

then

$
  phi(X, Y)
  = (1 - X - Y) + X - Y
  = 1 - 2Y.
$

So an expression in barycentric coordinates is just an ordinary function of the physical coordinates.

= Why This Is Useful For $P_1$ Elements

The space $P_1$ is the space of affine functions on the triangle.

Because

$
  lambda_1 + lambda_2 + lambda_3 = 1,
$

the functions $lambda_1$, $lambda_2$, $lambda_3$ span $P_1$.

Therefore, every $P_1$ function can be written as

$
  phi = alpha_1 lambda_1 + alpha_2 lambda_2 + alpha_3 lambda_3.
$

The coefficients have a simple meaning:

$
  phi(a_1) = alpha_1,
  quad
  phi(a_2) = alpha_2,
  quad
  phi(a_3) = alpha_3.
$

Indeed, at $a_1$, we have $(lambda_1, lambda_2, lambda_3) = (1, 0, 0)$, so

$
  phi(a_1) = alpha_1.
$

Similarly for $a_2$ and $a_3$.

= Example From TD5 Exercise 2

We want the $P_1$ basis function $phi_(12)$ associated with the midpoint $a_(12)$.

It must satisfy

$
  phi_(12)(a_(12)) = 1,
  quad
  phi_(12)(a_(13)) = 0,
  quad
  phi_(12)(a_(23)) = 0.
$

Write the most general affine function in barycentric coordinates:

$
  phi_(12) = alpha_1 lambda_1 + alpha_2 lambda_2 + alpha_3 lambda_3.
$

Now use the barycentric coordinates of the midpoints.

At $a_(12) : (1/2, 1/2, 0)$,

$
  phi_(12)(a_(12))
  = alpha_1 / 2 + alpha_2 / 2
  = 1.
$

At $a_(13) : (1/2, 0, 1/2)$,

$
  phi_(12)(a_(13))
  = alpha_1 / 2 + alpha_3 / 2
  = 0.
$

At $a_(23) : (0, 1/2, 1/2)$,

$
  phi_(12)(a_(23))
  = alpha_2 / 2 + alpha_3 / 2
  = 0.
$

Equivalently,

$
  alpha_1 + alpha_2 = 2,
  quad
  alpha_1 + alpha_3 = 0,
  quad
  alpha_2 + alpha_3 = 0.
$

Solving gives

$
  alpha_1 = 1,
  quad
  alpha_2 = 1,
  quad
  alpha_3 = -1.
$

Therefore

$
  phi_(12) = lambda_1 + lambda_2 - lambda_3.
$

Similarly,

$
  phi_(13) = lambda_1 - lambda_2 + lambda_3,
$

and

$
  phi_(23) = -lambda_1 + lambda_2 + lambda_3.
$

= Takeaway

To express a finite element basis function in barycentric coordinates:

+ Write the general polynomial using $lambda_1$, $lambda_2$, $lambda_3$.
+ Evaluate it at the nodes using the barycentric coordinates of those nodes.
+ Impose the Kronecker conditions $phi_i(s_j) = delta_(i j)$.
+ Solve for the coefficients.

For $P_1$, the general form is

$
  phi = alpha_1 lambda_1 + alpha_2 lambda_2 + alpha_3 lambda_3.
$

For $P_2$, the general form can be written with the six monomials

$
  lambda_1^2,
  lambda_2^2,
  lambda_3^2,
  lambda_1 lambda_2,
  lambda_1 lambda_3,
  lambda_2 lambda_3.
$

= Same Example In Matrix Form

We now redo the construction of $phi_(12)$, $phi_(13)$, and $phi_(23)$ using the matrix viewpoint.

We are working in $P_1$, so we choose the basis

$
  Q = (lambda_1, lambda_2, lambda_3).
$

The degrees of freedom are evaluation at the three midpoints:

$
  ell_1(p) = p(a_(12)),
  quad
  ell_2(p) = p(a_(13)),
  quad
  ell_3(p) = p(a_(23)).
$

Define the linear map

$
  T: P_1 -> RR^3,
  quad
  T(p) = mat(ell_1(p); ell_2(p); ell_3(p)).
$

The finite element basis functions are

$
  phi_(12) = T^(-1)(e_1),
  quad
  phi_(13) = T^(-1)(e_2),
  quad
  phi_(23) = T^(-1)(e_3),
$

where

$
  e_1 = mat(1; 0; 0),
  quad
  e_2 = mat(0; 1; 0),
  quad
  e_3 = mat(0; 0; 1).
$

== Building The Matrix

Let

$
  p = c_1 lambda_1 + c_2 lambda_2 + c_3 lambda_3.
$

The coefficient vector of $p$ in the basis $Q$ is

$
  [p]_Q = mat(c_1; c_2; c_3).
$

The matrix $M$ of $T$ in the basis $Q$ of $P_1$ and the canonical basis of $RR^3$ is defined by

$
  M_(i j) = ell_i(q_j),
$

where

$
  q_1 = lambda_1,
  quad
  q_2 = lambda_2,
  quad
  q_3 = lambda_3.
$

So each row is obtained by evaluating $lambda_1$, $lambda_2$, $lambda_3$ at one midpoint.

Since

$
  a_(12) : (1/2, 1/2, 0),
  quad
  a_(13) : (1/2, 0, 1/2),
  quad
  a_(23) : (0, 1/2, 1/2),
$

we get

$
  M = mat(
    1/2, 1/2, 0;
    1/2, 0, 1/2;
    0, 1/2, 1/2
  ).
$

Indeed,

$
  T(p) = M [p]_Q.
$

Explicitly,

$
  mat(
    p(a_(12));
    p(a_(13));
    p(a_(23))
  )
  =
  mat(
    1/2, 1/2, 0;
    1/2, 0, 1/2;
    0, 1/2, 1/2
  )
  mat(c_1; c_2; c_3).
$

== Inverting The Matrix

We need to solve

$
  M c^(k) = e_k
$

for $k = 1, 2, 3$. The inverse matrix is

$
  M^(-1) = mat(
    1, 1, -1;
    1, -1, 1;
    -1, 1, 1
  ).
$

Check:

$
  mat(
    1/2, 1/2, 0;
    1/2, 0, 1/2;
    0, 1/2, 1/2
  )
  mat(
    1, 1, -1;
    1, -1, 1;
    -1, 1, 1
  )
  =
  mat(
    1, 0, 0;
    0, 1, 0;
    0, 0, 1
  ).
$

The columns of $M^(-1)$ give the coefficients of the basis functions in the basis $Q = (lambda_1, lambda_2, lambda_3)$.

First column:

$
  c^(1) = mat(1; 1; -1).
$

Therefore

$
  phi_(12) = lambda_1 + lambda_2 - lambda_3.
$

Second column:

$
  c^(2) = mat(1; -1; 1).
$

Therefore

$
  phi_(13) = lambda_1 - lambda_2 + lambda_3.
$

Third column:

$
  c^(3) = mat(-1; 1; 1).
$

Therefore

$
  phi_(23) = -lambda_1 + lambda_2 + lambda_3.
$

== General Matrix Recipe

For a finite element $(K, P, Sigma)$, choose any convenient basis

$
  Q = (q_1, dots, q_m)
$

of $P$. Let

$
  Sigma = {ell_1, dots, ell_m}.
$

Build the matrix

$
  M_(i j) = ell_i(q_j).
$

Then:

- $M$ maps coefficients in the polynomial basis $Q$ to degrees of freedom.
- The element is unisolvent if and only if $M$ is invertible.
- The finite element basis functions are obtained from the columns of $M^(-1)$.

Precisely, if

$
  M^(-1) = (C_(j k))_(1 <= j,k <= m),
$

then

$
  phi_k = sum_(j=1)^m C_(j k) q_j.
$

This is exactly the change-of-basis computation from the polynomial basis $Q$ to the finite element basis $Phi = (phi_1, dots, phi_m)$.
