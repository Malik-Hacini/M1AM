#import "@preview/hei-synd-report:0.1.1": *
#import "metadata.typ": *
#import "extra.typ": *
//#show:make-glossary
//#register-glossary(entry-list)

//-------------------------------------
// Template config
//
#show: report.with(
  option: option,
  doc: doc,
  date: date,
  tableof: tableof,
)

//-------------------------------------
// Content
//
#counter(page).update(1)

= Introduction

= Part 1
= Part 2

We use the same notation as in the statement. The oven is
$Omega = ] -1.5, 1.5 [ times ] -1, 1 [$, the cooking region is
$S = ] -0.75, 0.75 [ times ] -0.5, 0.5 [$, and the six sources are the disks
$C_i$ of radius $0.05$ centered at the prescribed points. We write
$Gamma_t$ for the top wall, $Gamma_b$ for the bottom door, and $Gamma_l$,
$Gamma_r$ for the left and right walls. The coefficient is
$kappa = 1$ in $S$ and $kappa = 10$ in $Omega \ S$.

The top boundary condition is Dirichlet, so the natural affine space for the
temperature is
$ K = { w in H^1(Omega) | w = T_c " on " Gamma_t } $
and the test space is
$ V = { v in H^1(Omega) | v = 0 " on " Gamma_t } . $
For $u in H^1(Omega)$ and $v in V$, define
$
a(u, v)
  = integral_Omega kappa nabla u dot nabla v dif x
    + integral_(Gamma_b) kappa h u v dif s.
$
The bottom condition is the one written in the worksheet,
$partial_n T + h(T - T_e) = 0$. Therefore, after applying Green's formula to
$-op("div")(kappa nabla T)$, the Robin contribution is
$integral_(Gamma_b) kappa h T v dif s$ on the left-hand side and
$integral_(Gamma_b) kappa h T_e v dif s$ on the right-hand side. The lateral
insulation conditions are homogeneous Neumann conditions and therefore produce
no boundary term.

== Question 2(a)

For a coefficient vector $alpha = (alpha_1, dots, alpha_6)$, the weak direct
problem is: find $T(alpha) in K$ such that, for all $v in V$,
$
a(T(alpha), v)
  = integral_Omega (sum_(i=1)^6 alpha_i 1_(C_i)) v dif x
    + integral_(Gamma_b) kappa h T_e v dif s.
$
The dependence on $alpha$ is affine. We separate the affine boundary data from
the source terms.

First, define $T_0 in K$ by
$
a(T_0, v) = integral_(Gamma_b) kappa h T_e v dif s
quad "for all" v in V.
$
Equivalently, $T_0$ is the solution of the strong problem
$
-op("div")(kappa nabla T_0) &= 0 " in " Omega, \
T_0 &= T_c " on " Gamma_t, \
partial_n T_0 &= 0 " on " Gamma_l " and " Gamma_r, \
partial_n T_0 + h(T_0 - T_e) &= 0 " on " Gamma_b.
$

Then, for each $i = 1, dots, 6$, define $T_i in V$ by
$
a(T_i, v) = integral_(C_i) v dif x
quad "for all" v in V.
$
Equivalently, $T_i$ solves
$
-op("div")(kappa nabla T_i) &= 1_(C_i) " in " Omega, \
T_i &= 0 " on " Gamma_t, \
partial_n T_i &= 0 " on " Gamma_l " and " Gamma_r, \
partial_n T_i + h T_i &= 0 " on " Gamma_b.
$

We now prove the decomposition. Let
$
T^*(alpha) = T_0 + sum_(i=1)^6 alpha_i T_i.
$
Since $T_0 in K$ and each $T_i in V$, we have $T^*(alpha) in K$. For every
$v in V$, by linearity of $a$ in its first argument,
$
a(T^*(alpha), v)
  &= a(T_0, v) + sum_(i=1)^6 alpha_i a(T_i, v) \
  &= integral_(Gamma_b) kappa h T_e v dif s
     + sum_(i=1)^6 alpha_i integral_(C_i) v dif x \
  &= integral_(Gamma_b) kappa h T_e v dif s
     + integral_Omega (sum_(i=1)^6 alpha_i 1_(C_i)) v dif x.
$
Thus $T^*(alpha)$ satisfies exactly the variational formulation of the direct
problem. By uniqueness of the direct problem, obtained from the coercivity of
$a$ on $V$, we conclude that
$
T(alpha, x) = T_0 (x) + sum_(i=1)^6 alpha_i T_i (x).
$

== Question 2(b)

The objective is
$
J(alpha) = 1 / 2 integral_S abs(T(alpha, x) - T_s)^2 dif x.
$
Using the decomposition from Question 2(a), set
$
e_0(x) = T_0 (x) - T_s.
$
Then
$
J(alpha)
  = 1 / 2 integral_S abs(e_0 + sum_(j=1)^6 alpha_j T_j)^2 dif x.
$
This is a quadratic function of the six real variables $alpha_i$. For each
$i = 1, dots, 6$, differentiating under the integral gives
$
partial_(alpha_i) J(alpha)
  = integral_S (e_0 + sum_(j=1)^6 alpha_j T_j) T_i dif x.
$
At a minimizer $alpha^*$, all first derivatives vanish, hence
$
sum_(j=1)^6 (integral_S T_i T_j dif x) alpha_j^*
  = integral_S (T_s - T_0) T_i dif x,
quad i = 1, dots, 6.
$
Therefore the optimization problem is reduced to the linear system
$
A alpha^* = b,
$
where
$
A_(i j) = integral_S T_i T_j dif x,
quad
b_i = integral_S (T_s - T_0) T_i dif x.
$

The matrix $A$ is symmetric and positive semidefinite because, for every
$beta in RR^6$,
$
beta^T A beta
  = integral_S abs(sum_(i=1)^6 beta_i T_i)^2 dif x >= 0.
$
If the restrictions $T_1|_S, dots, T_6|_S$ are linearly independent in
$L^2(S)$, then $A$ is positive definite and the minimizer is unique. If they are
not independent, the same normal equations characterize the least-squares
minimizers, but uniqueness may be lost.

== Question 2(c)

The script `Project/optimization.edp` implements the previous construction with
$P_1$ finite elements on a $120 times 80$ rectangular mesh. It computes $T_0$,
then the six functions $T_i$, assembles the discrete normal system
$A^h alpha^h = b^h$, solves it, and finally performs a direct simulation with
the resulting source term.

For $T_s = 400 K$, the run gives
$
alpha_1^h &= 128523, \
alpha_2^h &= 151742, \
alpha_3^h &= 116486, \
alpha_4^h &= 403382, \
alpha_5^h &= 371042, \
alpha_6^h &= 367975.
$
With these coefficients, the direct simulation gives
$
integral_S 1 dif x &= 1.5, \
overline(T)_S &= 399.901 K, \
J(alpha^h) &= 4.63266, \
sqrt(2 J(alpha^h) / abs(S)) &= 2.48533 K, \
sqrt(1 / abs(S) integral_S abs(T - overline(T)_S)^2 dif x) &= 2.48335 K.
$
The mean temperature in $S$ is therefore very close to the target $400 K$, and
the root-mean-square error in $S$ is about $2.49 K$. The script also compares
the direct solution with $T_0 + sum_(i=1)^6 alpha_i^h T_i$ and obtains an
$L^2(Omega)$ difference of $8.3 times 10^(-12)$, which checks numerically the
linear decomposition used in the optimization.

= Part 3

= Conclusion


#bibliography("references.bib", style: "ieee", title: [References])
