#set page(paper: "a4", margin: 1.55cm)
#set text(size: 9.8pt, lang: "en")
#set par(justify: true, leading: 0.5em)
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 16pt, weight: "bold")[Exercise 4 Solutions]

  #text(size: 11pt)[Q1 and P1 finite element methods]
]

= Q1 Finite Element Method

== Reference Element And One Local Stiffness Entry

The reference square is $hat(K) = [0,1]^2$. The nodes are numbered anticlockwise from $(0,0)$, hence $hat(a)_1=(0,0)$, $hat(a)_2=(1,0)$, $hat(a)_3=(1,1)$, and $hat(a)_4=(0,1)$.

For the $Q_1$ element, $P = "span"(1, hat(x), hat(y), hat(x) hat(y))$. The local basis functions are $hat(phi)_i(hat(a)_j)=delta_(i j)$, hence

$hat(phi)_1=(1-hat(x))(1-hat(y))$, $hat(phi)_2=hat(x)(1-hat(y))$, $hat(phi)_3=hat(x)hat(y)$, and $hat(phi)_4=(1-hat(x))hat(y)$.

We verify the entry $(1,3)$ of the given matrix. Since $nabla hat(phi)_1=(hat(y)-1, hat(x)-1)$ and $nabla hat(phi)_3=(hat(y), hat(x))$, we get

$
  integral_(hat(K)) nabla hat(phi)_1 dot nabla hat(phi)_3 dif hat(x) dif hat(y)
  = integral_0^1 integral_0^1 (hat(y)^2 - hat(y) + hat(x)^2 - hat(x)) dif hat(x) dif hat(y).
$

Thus

$
  integral_(hat(K)) nabla hat(phi)_1 dot nabla hat(phi)_3
  = (1/3 - 1/2) + (1/3 - 1/2)
  = -1/3 = -2/6.
$

This matches the coefficient in row $1$, column $3$ of

$
  1/6 mat(
    4, -1, -2, -1;
    -1, 4, -1, -2;
    -2, -1, 4, -1;
    -1, -2, -1, 4
  ).
$

== Global Matrix On $Omega = (0,3) times (0,2)$

The mesh contains six unit squares. Since the boundary condition is homogeneous Dirichlet, all boundary vertex values are fixed to zero. The only interior vertices are $P_1=(1,1)$ and $P_2=(2,1)$. We use the global basis functions $Phi_1$ and $Phi_2$ associated with these two vertices.

The local stiffness matrix on each unit square is exactly the reference matrix above. Each interior vertex belongs to four unit squares. Since the diagonal local entry is $4/6=2/3$, we have $A_(1 1)=A_(2 2)=4 dot 2/3 = 8/3$.

The two interior vertices share the edge between $(1,1)$ and $(2,1)$. This edge belongs to two unit squares. In each of these two squares, the corresponding local coefficient is $-1/6$. Therefore $A_(1 2)=A_(2 1)=2 dot (-1/6)=-1/3$.

Thus the assembled global stiffness matrix, in the ordering $P_1=(1,1)$, $P_2=(2,1)$, is

$
  A = mat(
    8/3, -1/3;
    -1/3, 8/3
  )
  = 1/3 mat(8, -1; -1, 8).
$

For completeness, since $f=1$, the right-hand side is $F_i=integral_Omega Phi_i$. Each interior node touches four unit squares and the integral of one local $Q_1$ basis function over a unit square is $1/4$, so $F=mat(1;1)$. The resulting discrete system would be $A U = F$.

= P1 Finite Element Method

We now consider $Omega=(0,1) times (0,1)$ with the mesh shown in the statement: a $2 times 2$ grid, each small square cut by its lower-left to upper-right diagonal. Thus each small triangle has area $1/8$.

== Associated Boundary Value Problem

The variational formulation is

$
  "Find " u in V " such that "
  integral_Omega nabla u dot nabla v dif x dif y
  = integral_Omega v dif x dif y
  quad forall v in V,
$

where $V={v in H^1(Omega): v=0 " on " Gamma_D}$ with $Gamma_D=(0,1) times {0}$.

Assume temporarily that $u$ is smooth. Green's formula gives $integral_Omega nabla u dot nabla v = - integral_Omega Delta u v + integral_(partial Omega) partial_n u v$. Since $v=0$ on $Gamma_D$ and is arbitrary on the remaining boundary, the associated strong problem is

$
  cases(
    -Delta u = 1 & "in " Omega,
    u = 0 & "on " Gamma_D=(0,1) times {0},
    partial_n u = 0 & "on the remaining boundary, up to corners.",
  )
$

The Dirichlet condition is essential, because it is built into the space $V$. The Neumann condition is natural, because it appears from the boundary term in Green's formula.

== Discrete Space And Dimension

Let $cal(T)_h$ be the triangulation. The $P_1$ finite element space is $V_h={v_h in C^0(overline(Omega)): v_h|_T in P_1 " for all " T in cal(T)_h, v_h=0 " on " Gamma_D}$.

The mesh has $9$ vertices. The three bottom vertices $(0,0)$, $(1/2,0)$, and $(1,0)$ lie on $Gamma_D$ and are fixed to zero. The other six vertices are degrees of freedom. Hence $dim V_h=6$.

We use the numbering

#table(
  columns: 6,
  align: horizon,
  [$1$], [$2=c$], [$3$], [$4$], [$5$], [$6$],
  [$(0,1/2)$], [$(1/2,1/2)$], [$(1,1/2)$], [$(0,1)$], [$(1/2,1)$], [$(1,1)$],
)

where $c=(1/2,1/2)$ is the central node.

== Zero Entries Of The Stiffness Matrix

Here the goal is only to identify which entries of $A$ are zero. We do not need to compute the non-zero coefficients.

Let $phi_i$ be the global basis function associated with degree of freedom $i$. The stiffness matrix is $A_(i j)=integral_Omega nabla phi_j dot nabla phi_i$. Since $phi_i$ and $phi_j$ are piecewise affine, this integral is a sum over triangles. A triangle contributes to $A_(i j)$ only if it contains both vertices $i$ and $j$.

We use two facts:

- If two nodes $i$ and $j$ do not belong to a common triangle, then $A_(i j)=0$.
- If $i$ and $j$ are the two endpoints of the hypotenuse of a right triangle $T$, then the local contribution on $T$ is zero. Indeed, for $P_1$ basis functions, $integral_T nabla lambda_i dot nabla lambda_j = -1/2 cot(theta_k)$, where $theta_k$ is the angle at the third vertex. If $theta_k=pi/2$, then $cot(theta_k)=0$.

Denote the bottom Dirichlet vertices by $b_0=(0,0)$, $b_1=(1/2,0)$, and $b_2=(1,0)$. With the numbering chosen above, the eight triangles are

#table(
  columns: 4,
  align: horizon,
  [$T_1$], [$T_2$], [$T_3$], [$T_4$],
  [$(b_0,b_1,2)$], [$(b_0,2,1)$], [$(b_1,b_2,3)$], [$(b_1,3,2)$],
  [$T_5$], [$T_6$], [$T_7$], [$T_8$],
  [$(1,2,5)$], [$(1,5,4)$], [$(2,3,6)$], [$(2,6,5)$],
)

Now inspect pairs $1 <= i < j <= 6$.

Pairs with no common triangle are $(1,3)$, $(1,6)$, $(2,4)$, $(3,4)$, $(3,5)$, and $(4,6)$. Hence the corresponding entries are zero.

Two additional pairs do share triangles, but only as hypotenuse endpoints. The pair $(1,5)$ is the diagonal of the upper-left square, so it is the hypotenuse in both $T_5=(1,2,5)$ and $T_6=(1,5,4)$; both local contributions vanish. Similarly, $(2,6)$ is the diagonal of the upper-right square, so it is the hypotenuse in both $T_7=(2,3,6)$ and $T_8=(2,6,5)$; both local contributions vanish.

Therefore the zero off-diagonal entries are exactly $(1,3)$, $(1,5)$, $(1,6)$, $(2,4)$, $(2,6)$, $(3,4)$, $(3,5)$, and $(4,6)$, together with their symmetric counterparts. No diagonal entry is zero.

== Integral Of The Central Basis Function

Let $phi_c$ be the global basis function associated with $c=(1/2,1/2)$. Its support is the union of the six triangles containing $c$.

On each triangle $T$ containing $c$, the restriction of $phi_c$ is the barycentric coordinate associated with $c$. Therefore $integral_T phi_c = |T|/3$. Since each small triangle has area $1/8$, each contribution is $1/24$. There are six such triangles, hence

$
  integral_Omega phi_c dif x dif y = 6 dot 1/24 = 1/4.
$

== Energy Of The Central Basis Function

We compute $integral_Omega |nabla phi_c|^2$. Again, only the six triangles containing $c$ contribute.

Let $h=1/2$. On a right triangle with legs $h$ where $c$ is an acute vertex, the basis function associated with $c$ has gradient of squared norm $1/h^2=4$, and the contribution is $(h^2/2) dot 1/h^2 = 1/2$.

On a right triangle with legs $h$ where $c$ is the right-angle vertex, the basis function has gradient of squared norm $2/h^2=8$, and the contribution is $(h^2/2) dot 2/h^2 = 1$.

In the given mesh, among the six triangles containing $c$, the node $c$ is the right-angle vertex in two triangles and an acute vertex in four triangles. Therefore

$
  integral_Omega |nabla phi_c|^2 dif x dif y
  = 2 dot 1 + 4 dot 1/2
  = 4.
$

Equivalently, this is the diagonal matrix entry $A_(2 2)$ in the numbering above, and the assembled matrix indeed gives $A_(2 2)=4$.
