#set page(paper: "a4", margin: 1.45cm)
#set text(size: 9.5pt, lang: "en")
#set par(justify: true, leading: 0.48em)
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 16pt, weight: "bold")[Q1 Finite Elements And Stiffness Assembly]

  #text(size: 11pt)[Compact cheatsheet with course notation]
]

= Q1 Reference Element

Course notation: $K = [0, 1]^2$, $P = "span"(1, x, y, x y)$, and $Sigma = {p -> p(0,0), p -> p(1,0), p -> p(0,1), p -> p(1,1)}$.

Node ordering: $a_1 = (0,0)$, $a_2 = (1,0)$, $a_3 = (0,1)$, $a_4 = (1,1)$.

Local basis functions: $phi_1 = (1-x)(1-y)$, $phi_2 = x(1-y)$, $phi_3 = (1-x)y$, $phi_4 = x y$. They satisfy $phi_i(a_j) = delta_(i j)$, hence every $p in Q_1$ satisfies $p(x,y) = sum_(i=1)^4 p(a_i) phi_i(x,y)$.

Interpretation: $Q_1$ is the tensor product of two one-dimensional $P_1$ elements. It is affine in each variable separately, but not globally affine because of the $x y$ term.

= Global Q1 Space

On a rectangular mesh $(K_l)_(1 <= l <= N_t)$ of $Omega$, define $V_h = {v_h in C^0(overline(Omega)) : v_h|_(K_l) in Q_1, forall l}$. If the mesh has $N_v$ vertices, then $dim V_h = N_v$.

The global basis functions $Phi_i$ satisfy $Phi_i(a_j) = delta_(i j)$ for all global vertices $a_j$. For homogeneous Dirichlet boundary conditions, use $V_(h,0) = V_h ∩ H^1_0(Omega) = "span" {Phi_i : a_i " is an interior vertex"}$.

= Model Problem And Matrix Form

For $-Delta u = f$ in $Omega$, $u = 0$ on $partial Omega$, the variational formulation is

$
  "Find " u in H^1_0(Omega) " such that "
  integral_Omega nabla u dot nabla v dif x
  = integral_Omega f v dif x
  quad forall v in H^1_0(Omega).
$

The discrete formulation is the same with $H^1_0(Omega)$ replaced by $V_(h,0)$. Writing $u_h = sum_j U_j Phi_j$ gives $A U = F$, with $A_(i j) = integral_Omega nabla Phi_j dot nabla Phi_i dif x$ and $F_i = integral_Omega f Phi_i dif x$. The matrix $A$ is the global stiffness matrix.

= Reference Local Stiffness Matrix

On $K = [0,1]^2$, define $K^"ref"_(i j) = integral_K nabla phi_j dot nabla phi_i dif x dif y$. With the node ordering $(0,0)$, $(1,0)$, $(0,1)$, $(1,1)$:

$
  K^"ref" = mat(
    2/3, -1/6, -1/6, -1/3;
    -1/6, 2/3, -1/3, -1/6;
    -1/6, -1/3, 2/3, -1/6;
    -1/3, -1/6, -1/6, 2/3
  ).
$

For rectangular cells, keep the derivative split. Define $K_x^"ref"_(i j) = integral_K partial_x phi_j partial_x phi_i dif x dif y$ and $K_y^"ref"_(i j) = integral_K partial_y phi_j partial_y phi_i dif x dif y$. Then $K^"ref" = K_x^"ref" + K_y^"ref"$, with

$
  K_x^"ref" = mat(
    1/3, -1/3, 1/6, -1/6;
    -1/3, 1/3, -1/6, 1/6;
    1/6, -1/6, 1/3, -1/3;
    -1/6, 1/6, -1/3, 1/3
  ),
  quad
  K_y^"ref" = mat(
    1/3, 1/6, -1/3, -1/6;
    1/6, 1/3, -1/6, -1/3;
    -1/3, -1/6, 1/3, 1/6;
    -1/6, -1/3, 1/6, 1/3
  ).
$

= Physical Rectangle

Let $K_l = [x_i, x_(i+1)] times [y_j, y_(j+1)]$, with $h_x = x_(i+1) - x_i$ and $h_y = y_(j+1) - y_j$. The affine map from the reference square is $F_l(hat(x), hat(y)) = (x_i + h_x hat(x), y_j + h_y hat(y))$.

The physical basis functions are $phi_r^l = phi_r compose F_l^(-1)$ for $r = 1, dots, 4$. The physical local stiffness matrix is $K^l_(r s) = integral_(K_l) nabla phi_s^l dot nabla phi_r^l dif x dif y$.

By change of variables,

$
  K^l = (h_y / h_x) K_x^"ref" + (h_x / h_y) K_y^"ref".
$

If $h_x = h_y$, then $K^l = K^"ref"$. This scale cancellation is specific to the pure Laplace stiffness matrix in dimension $2$.

= Local Load Vector

The local load vector is $F^l_r = integral_(K_l) f phi_r^l dif x dif y$. On the reference element,

$
  F^l_r = h_x h_y integral_[0,1]^2 f(F_l(hat(x), hat(y))) phi_r(hat(x), hat(y)) dif hat(x) dif hat(y).
$

If $f$ is simple, compute this exactly. Otherwise use quadrature.

= Assembly Method

For every cell $K_l$, define the local-to-global map $I_l: {1,2,3,4} -> {1, dots, N_v}$, where $I_l(r)$ is the global index of local node $r$.

Assembly means adding local contributions into global entries:

$
  A_(I_l(r), I_l(s)) += K^l_(r s),
  quad
  F_(I_l(r)) += F^l_r.
$

Precise algorithm:

```text
Initialize A = 0 and F = 0.

For each element K_l:
  get global indices I_l(1), ..., I_l(4)
  compute K^l and F^l
  for r = 1,...,4:
    F[I_l(r)] += F^l[r]
  for r = 1,...,4 and s = 1,...,4:
    A[I_l(r), I_l(s)] += K^l[r,s]
```

This works because global basis functions are obtained by gluing local basis functions. A global entry $A_(i j)$ is the sum of the local integrals over all cells touching both nodes $i$ and $j$.

= Dirichlet Boundary Conditions

If $u = 0$ on $partial Omega$, boundary vertex values are fixed to zero. The clean variational method is to assemble only the interior unknowns: $V_(h,0) = "span" {Phi_i : a_i " is interior"}$. Equivalently, one may assemble the full system and replace each boundary row by an identity row with $F_i = 0$.

If $u = g$ on $partial Omega$, write $u_h = w_h + g_h$, where $w_h in V_(h,0)$ and $g_h$ is the $Q_1$ interpolant of the boundary data. Then solve

$
  integral_Omega nabla w_h dot nabla v_h dif x
  = integral_Omega f v_h dif x
    - integral_Omega nabla g_h dot nabla v_h dif x
  quad forall v_h in V_(h,0).
$

In matrix form, after splitting interior and boundary indices, $A_(I I) U_I = F_I - A_(I B) G_B$.

= Mass Matrix Reminder

For $-Delta u + u = f$, the bilinear form is $a(u,v) = integral_Omega nabla u dot nabla v dif x + integral_Omega u v dif x$. Add the local mass matrix $M^l$ to the local stiffness matrix.

On the reference square, $M^"ref"_(i j) = integral_K phi_j phi_i dif x dif y$, and

$
  M^"ref" = mat(
    1/9, 1/18, 1/18, 1/36;
    1/18, 1/9, 1/36, 1/18;
    1/18, 1/36, 1/9, 1/18;
    1/36, 1/18, 1/18, 1/9
  ).
$

On $K_l$, $M^l = h_x h_y M^"ref"$. For $-Delta u + u = f$, assemble $A^l = K^l + M^l$.

= Minimal Checklist

+ Local ordering: $(0,0)$, $(1,0)$, $(0,1)$, $(1,1)$.
+ Local basis: $phi_1 = (1-x)(1-y)$, $phi_2 = x(1-y)$, $phi_3 = (1-x)y$, $phi_4 = x y$.
+ Rectangle formula: $K^l = (h_y / h_x) K_x^"ref" + (h_x / h_y) K_y^"ref"$.
+ Assembly: add $K^l_(r s)$ into $A_(I_l(r), I_l(s))$ and $F^l_r$ into $F_(I_l(r))$.
+ Dirichlet: keep only interior nodes, or impose boundary rows after full assembly.
