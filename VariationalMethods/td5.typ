#set page(paper: "a4", margin: 2cm)
#set text(size: 11pt, lang: "en")
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 17pt, weight: "bold")[TD5 Correction]

  #v(0.3em)
  #text(size: 13pt)[Exercises 1 and 2: Unisolvent finite elements]
]

#v(1em)

= Exercise 1

== Statement

Let

$
  K = [0, 1] times [0, 1]
$

with nodes

$
  A_1 = (0, 0), quad
  A_2 = (1, 0), quad
  A_3 = (1, 1), quad
  A_4 = (0, 1), quad
  A_5 = (1/2, 1/2).
$

We consider

$
  cal(P) = "span" { 1, x, y, x y, y^2, x^2 }
$

and

$
  Sigma = {
    p -> p(A_1),
    p -> p(A_2),
    p -> p(A_3),
    p -> p(A_4),
    p -> p(A_5),
    p -> integral_K p(x, y) dif x dif y
  }.
$

We want to decide whether $(K, cal(P), Sigma)$ is unisolvent.

== Strategy

The space $cal(P)$ has dimension $6$, since the six monomials

$
  1, x, y, x y, y^2, x^2
$

are linearly independent.

The set $Sigma$ also has $6$ linear forms. Therefore, the finite element is unisolvent if and only if the only polynomial $p in cal(P)$ cancelling all forms in $Sigma$ is the zero polynomial.

Equivalently, if

$
  T: cal(P) -> RR^6,
  quad
  T(p) = (p(A_1), p(A_2), p(A_3), p(A_4), p(A_5), integral_K p),
$

then unisolvency is equivalent to $T$ being injective, hence bijective.

== Kernel Computation

Let

$
  p(x, y) = a + b x + c y + d x y + e y^2 + f x^2.
$

We impose that all degrees of freedom vanish.

First,

$
  p(A_1) = p(0, 0) = a = 0.
$

Then

$
  p(A_2) = p(1, 0) = a + b + f = 0,
$

so, since $a = 0$,

$
  b + f = 0.
$

Similarly,

$
  p(A_4) = p(0, 1) = a + c + e = 0,
$

so

$
  c + e = 0.
$

At the vertex $A_3 = (1, 1)$,

$
  p(A_3) = a + b + c + d + e + f = 0.
$

Using $a = 0$, $b = -f$, and $c = -e$, this gives

$
  -f - e + d + e + f = d = 0.
$

At the center $A_5 = (1/2, 1/2)$,

$
  p(A_5)
  = a + b/2 + c/2 + d/4 + e/4 + f/4 = 0.
$

Using $a = 0$ and $d = 0$, we get

$
  b/2 + c/2 + e/4 + f/4 = 0.
$

Using $b = -f$ and $c = -e$, this becomes

$
  -f/2 - e/2 + e/4 + f/4 = - (e + f) / 4 = 0.
$

Therefore

$
  e + f = 0.
$

Finally, compute the integral:

$
  integral_K p(x, y) dif x dif y
  = a + b/2 + c/2 + d/4 + e/3 + f/3.
$

Using

$
  a = 0,
  quad b = -f,
  quad c = -e,
  quad d = 0,
  quad e = -f,
$

we obtain

$
  integral_K p(x, y) dif x dif y
  = -f/2 + f/2 - f/3 + f/3 = 0.
$

Thus the integral condition adds no further constraint.

Consequently, all polynomials in the kernel are of the form

$
  p(x, y) = f (x^2 - x + y - y^2),
  quad f in RR.
$

In particular, the kernel is not reduced to ${0}$.

== Explicit Non-Zero Polynomial Cancelling All Degrees Of Freedom

Choose $f = 1$ and define

$
  p_0(x, y) = x^2 - x + y - y^2.
$

This polynomial is non-zero and belongs to $cal(P)$.

We verify each degree of freedom.

At the vertices:

$
  p_0(A_1) = p_0(0, 0) = 0,
$

$
  p_0(A_2) = p_0(1, 0) = 1 - 1 = 0,
$

$
  p_0(A_3) = p_0(1, 1) = 1 - 1 + 1 - 1 = 0,
$

$
  p_0(A_4) = p_0(0, 1) = 1 - 1 = 0.
$

At the center:

$
  p_0(A_5)
  = p_0(1/2, 1/2)
  = 1/4 - 1/2 + 1/2 - 1/4
  = 0.
$

For the integral:

$
  integral_K p_0(x, y) dif x dif y
  = integral_0^1 integral_0^1 (x^2 - x + y - y^2) dif x dif y.
$

Since the square has unit measure,

$
  integral_K x^2 dif x dif y = 1/3,
  quad
  integral_K x dif x dif y = 1/2,
$

and

$
  integral_K y dif x dif y = 1/2,
  quad
  integral_K y^2 dif x dif y = 1/3.
$

Therefore

$
  integral_K p_0(x, y) dif x dif y
  = 1/3 - 1/2 + 1/2 - 1/3
  = 0.
$

Thus $p_0$ cancels every element of $Sigma$, but $p_0 != 0$.

== Matrix Verification

Using the ordered basis

$
  Q = (1, x, y, x y, y^2, x^2)
$

of $cal(P)$, the matrix of $T$ is

$
  M = mat(
    1, 0, 0, 0, 0, 0;
    1, 1, 0, 0, 0, 1;
    1, 1, 1, 1, 1, 1;
    1, 0, 1, 0, 1, 0;
    1, 1/2, 1/2, 1/4, 1/4, 1/4;
    1, 1/2, 1/2, 1/4, 1/3, 1/3
  ).
$

Indeed, if

$
  [p]_Q = mat(a; b; c; d; e; f),
$

then

$
  T(p) = M [p]_Q.
$

Exact row reduction gives

$
  "rref"(M) = mat(
    1, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 1;
    0, 0, 1, 0, 0, -1;
    0, 0, 0, 1, 0, 0;
    0, 0, 0, 0, 1, 1;
    0, 0, 0, 0, 0, 0
  ).
$

Thus $"rank"(M) = 5 < 6$, so $M$ is not invertible. The vector

$
  mat(0; -1; 1; 0; -1; 1)
$

is in the kernel, and it corresponds exactly to

$
  p_0(x, y) = x^2 - x + y - y^2.
$

== Conclusion

The finite element $(K, cal(P), Sigma)$ is *not unisolvent*.

Indeed, the non-zero polynomial

$
  p_0(x, y) = x^2 - x + y - y^2
$

belongs to $cal(P)$ and satisfies

$
  p_0(A_i) = 0 quad "for" i = 1, dots, 5,
  quad
  integral_K p_0(x, y) dif x dif y = 0.
$

Therefore the degrees of freedom do not uniquely determine a polynomial in $cal(P)$. Consequently, there are no finite element basis functions dual to $Sigma$ in the unisolvent sense.

= Exercise 2

== Statement And Notation

Let $K$ be a triangle with vertices $a_1$, $a_2$, $a_3$. We denote by $lambda_1$, $lambda_2$, $lambda_3$ the barycentric coordinates on $K$, so that

$
  lambda_1 + lambda_2 + lambda_3 = 1,
$

and

$
  a_1 : (1, 0, 0), quad
  a_2 : (0, 1, 0), quad
  a_3 : (0, 0, 1).
$

The midpoints of the edges are denoted by

$
  a_(12), quad a_(13), quad a_(23).
$

Their barycentric coordinates are

$
  a_(12) : (1/2, 1/2, 0), quad
  a_(13) : (1/2, 0, 1/2), quad
  a_(23) : (0, 1/2, 1/2).
$

The set of midpoints is

$
  S_1 = {a_(12), a_(13), a_(23)}.
$

The six points dividing each edge into three equal parts are

$
  a_(i i j) = (2 a_i + a_j) / 3,
  quad i != j.
$

In barycentric coordinates, $a_(i i j)$ is the point with

$
  lambda_i = 2/3,
  quad lambda_j = 1/3,
  quad lambda_k = 0,
$

where ${i, j, k} = {1, 2, 3}$. The set of these six points is

$
  S_2 = {a_(i i j) : i != j}.
$

For $i = 1, 2$, the degrees of freedom are

$
  Sigma_i = {p -> p(s) : s in S_i}.
$

We study the finite elements $(K, P_k, Sigma_i)$ for $k = 1, 2$.

Recall that, on a triangle,

$
  dim P_1 = 3,
  quad
  dim P_2 = 6.
$

== Case $(K, P_1, Sigma_1)$

Here $"card"(Sigma_1) = 3$ and $dim P_1 = 3$, so unisolvency is possible.

We prove that it is indeed unisolvent and construct the basis functions.

The degrees of freedom are evaluations at

$
  a_(12), quad a_(13), quad a_(23).
$

We seek basis functions $phi_(12)$, $phi_(13)$, $phi_(23) in P_1$ such that

$
  phi_(r)(s) = delta_(r s)
$

for $r, s in {12, 13, 23}$.

The correct functions are

$
  phi_(12) = lambda_1 + lambda_2 - lambda_3,
$

$
  phi_(13) = lambda_1 - lambda_2 + lambda_3,
$

$
  phi_(23) = -lambda_1 + lambda_2 + lambda_3.
$

Equivalently, using $lambda_1 + lambda_2 + lambda_3 = 1$,

$
  phi_(12) = 1 - 2 lambda_3,
  quad
  phi_(13) = 1 - 2 lambda_2,
  quad
  phi_(23) = 1 - 2 lambda_1.
$

Verification:

$
  phi_(12)(a_(12)) = 1/2 + 1/2 - 0 = 1,
  quad
  phi_(12)(a_(13)) = 1/2 + 0 - 1/2 = 0,
  quad
  phi_(12)(a_(23)) = 0 + 1/2 - 1/2 = 0.
$

Similarly,

$
  phi_(13)(a_(13)) = 1,
  quad
  phi_(13)(a_(12)) = phi_(13)(a_(23)) = 0,
$

and

$
  phi_(23)(a_(23)) = 1,
  quad
  phi_(23)(a_(12)) = phi_(23)(a_(13)) = 0.
$

Thus the three functions are dual to the three degrees of freedom. Therefore $(K, P_1, Sigma_1)$ is unisolvent.

For every $p in P_1$, one has the interpolation formula

$
  p = p(a_(12)) phi_(12)
    + p(a_(13)) phi_(13)
    + p(a_(23)) phi_(23).
$

== Case $(K, P_2, Sigma_1)$

Here

$
  "card"(Sigma_1) = 3,
  quad
  dim P_2 = 6.
$

Therefore the finite element cannot be unisolvent: there are not enough degrees of freedom to determine a quadratic polynomial on a triangle.

More explicitly, the non-zero polynomial

$
  q(lambda_1, lambda_2, lambda_3) = lambda_1 (2 lambda_1 - 1)
$

belongs to $P_2$ and vanishes at all three midpoints:

$
  q(a_(12)) = q(a_(13)) = 0
$

because $lambda_1 = 1/2$ at both $a_(12)$ and $a_(13)$, while

$
  q(a_(23)) = 0
$

because $lambda_1 = 0$ at $a_(23)$.

Since $q(a_1) = 1$, $q$ is not the zero polynomial. Hence $(K, P_2, Sigma_1)$ is not unisolvent.

== Case $(K, P_1, Sigma_2)$

Here

$
  "card"(Sigma_2) = 6,
  quad
  dim P_1 = 3.
$

Thus the map

$
  T: P_1 -> RR^6,
  quad
  T(p) = (p(s))_(s in S_2)
$

cannot be surjective. It is impossible to prescribe six arbitrary real values using only an affine polynomial, which has only three independent coefficients.

Therefore $(K, P_1, Sigma_2)$ is not unisolvent.

== Case $(K, P_2, Sigma_2)$

Here

$
  "card"(Sigma_2) = 6,
  quad
  dim P_2 = 6.
$

The dimension count is compatible with unisolvency, but it is not sufficient. We must check injectivity.

Consider the polynomial

$
  q(lambda_1, lambda_2, lambda_3)
  = lambda_1^2 + lambda_2^2 + lambda_3^2
    - 5/2 (lambda_1 lambda_2 + lambda_1 lambda_3 + lambda_2 lambda_3).
$

This is a non-zero element of $P_2$. Indeed,

$
  q(a_1) = 1.
$

Now take any point $a_(i i j) in S_2$. If ${i, j, k} = {1, 2, 3}$, then

$
  lambda_i = 2/3,
  quad lambda_j = 1/3,
  quad lambda_k = 0.
$

Therefore

$
  q(a_(i i j))
  = (2/3)^2 + (1/3)^2
    - 5/2 (2/3 dot 1/3)
  = 4/9 + 1/9 - 5/2 dot 2/9
  = 5/9 - 5/9
  = 0.
$

The same computation applies to all six points of $S_2$. Thus $q$ cancels every degree of freedom in $Sigma_2$, but $q != 0$.

Consequently, the kernel of the degree-of-freedom map is non-trivial, and $(K, P_2, Sigma_2)$ is not unisolvent.

== Summary

The four cases are:

#table(
  columns: 4,
  align: horizon,
  [Space], [Degrees of freedom], [Unisolvent?], [Reason],
  [$P_1$], [$Sigma_1$], [Yes], [Midpoint values determine an affine function],
  [$P_2$], [$Sigma_1$], [No], [$3 < dim P_2 = 6$],
  [$P_1$], [$Sigma_2$], [No], [$6 > dim P_1 = 3$, not onto],
  [$P_2$], [$Sigma_2$], [No], [Non-zero quadratic cancels all six values],
)

The only unisolvent finite element in this exercise is $(K, P_1, Sigma_1)$, whose basis functions are

$
  phi_(12) = lambda_1 + lambda_2 - lambda_3,
  quad
  phi_(13) = lambda_1 - lambda_2 + lambda_3,
  quad
  phi_(23) = -lambda_1 + lambda_2 + lambda_3.
$
