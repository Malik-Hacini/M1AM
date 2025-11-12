#import "lib.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/diverential:0.2.0" : *

#show: template.with(
  title: [Geometric Modeling],
  short_title: "Geometric Modeling",
  description: [  Notes based on a course given by Boris Thibert for M1 Applied Mathematics, Université Grenoble Alpes.
  ],
  authors: (
    (
      name: "Malik Hacini",
    ),
  ),
  
  // lof: true,
  // lot: true,
  // lol: true,
  paper_size: "a4",
  // landscape: true,
  cols: 1,
  text_font: "STIX Two Text",
  accent: "#1A41AC", // blue
  h1-prefix: "Chapter",
  colortab: false,

)


= Interpolation

== Lagrange interpolation

#theorem[
Let  $a = t_0 < ... < t_n =b$, $y_0, ..., y_n in RR$

There exists a unique polynomial $L_n$ of degree $<=n$ such that: 

$
forall  i in {0, n}, L_n (t_i) = y_i
$

These polynomials are called Lagrange interpolation polynomials 
A simple expression is :

$

L_n (t) = sum_(i=0)^n y_i P_i (t),\

#text[where ]P_i (t) = display(product_(i != j)^()  (t-t_j)/(t_i - t_j))

$
]

#proof[ We denote $E = RR_n [X]$ the space of polynomials of degree $<= n$.

- E is a $RR$-vector space 
- Let $ phi : E &arrow.long RR^(n+1)\
P &arrow.bar.long (P(t_0), ..., P(t_n)) $

$phi$ is a linear map between vector spaces of some dimension.
To prove the result, we need $phi$ to be one-to-one map.

Let $P in ker phi$

Then :

- $P$ is of degree $<= n$

- P vanishes at n+1 points

then by the fundamental theorem of algrebra, $P eq.triple 0$]

=== Runge Phenomenon

We observe in practice the Runge Phenomenon
Let $ f : [-1, 1] arrow RR \ x arrow.bar 1/(1+25x^2) $

ti uniformly distributed in $[-1, 1]$

We observe $norm(L_n - f)_infinity arrow.long_(n arrow + infinity) + infinity$

We have an approximation result :

#theorem[ :

Let $f : [a,b] arrow RR in cal(C)^(n+1)$ 

$L_n$ the Lagrange polynoomial associated to $a=t_0<...<t_n = b$

Then $norm(f-L_n) <= 1/((n+1)!) norm(q_(n+1))_infinity norm(f^(n+1))_infinity$

when $q_(n+1)(t) = Pi_(i=0)^n (t-t_i)$
]
Runge phenomenon : $norm(f^(n+1))_infinity$ goes to infinity quickly


#proof[

We introduce the error $g=f-L_n$

Let $t in [0,b]\{t_i}$
$
k(u) := g(u) - q_(n+1) (u) (g(t))/(q_(n+1) (t))\

k(t_i) = 0 #text[ for ] i = 0, ..., n \ 
k(t) = 0\
$
$k(t)$ vanishes at $(n+2)$ points

so $k'(t)$ vanishes at $(n+1)$ points (by Rolle)

so $k^(n+1)$ vanishes at 1 point $xi$

=> $0 = k^(n+1)(xi) = g^(n+1) (xi) - q_(n+1)^(n+1) (xi) g(t)/(q_(n+1) (t))$

$g^(n+1) = f(n+1) (xi)$ and $q^(n+1) = (n+1)!$

=> $abs(g(t)) = 1/((n+1)!) q_(n+1) (t) f^(n+1) (xi) lt.eq norm(...)_infinity$]


== Interpolation with splines

#theorem[ 

Let $y_0, ...,y_n in RR$ 

$a = t_0, ..., t_n = b$ and $alpha, beta in RR$

Then there exists a unique function $S$

such that 
- $S_(|[t_i, t_(i+1)])$ is a polynomial of degree $lt.eq 3$
- $S$ is $cal(C)^2$
- $S(t_i) = y_i$
- $S'(a) = alpha$ and $S'(b) = beta$
]

order of continuity is one less than the order of polynomial (see order 0 case)


This function $S$  is called cubic splines

=== Minimization result

#theorem[
Let $y_0, ..., y_n in RR$ ...

Then the associated spline $S$ satisfies  :

$ S = arg min integral_a^b f''(t)² d t $
]
So splines are the solution to the minimization problem of reducing the energy ($L^2$ norm) of the second derivative.

* Skecth of proof * :
Let $g in E$ and  $e = f-S$ the error with S spline

Step 1 :

Show

$forall h:[a,b] arrow cal(C)^0$, linear on $[t_i, t_i+1]$,
$ integral_a^b e''(x) h(x) d x = 0 $

Step 2:

$
integral_a^b f''^2 &= integral (e+S)^2 \
&= integral e''^2 + 2 integral  e'' S'' + integral S''^2\
&= integral e''^2 + integral S''^2\
=> forall f in E integral f''² >= integral S''^2
$

We need to show uniqueness of the minimizer

If $integral f''² = integral S''²$ then $integral e''²=0$


= Differential geometry of curves

== Representation of curves

- Drawings
- Parametrized curves :
$ gamma: [a,b] -> RR^d $

- Implicit representation:
$ cal(C) = {(x,y), x^2 + y^2 = R^2} = f^(-1) (0) #text[where] f : t-> x^2 + y^2 - R^2
$


== Generalities on parametrized curves

=== Reminder :
 Let $f : [a,b] subset RR -> RR^2$ of class $cal(C)^n$, and $t_0 in ]a,b[$. Performing a Taylor expansion around $t_0$ yields :

$ f(t) = f(t_0) + (t-t_0)f'(t_0) + (t-t_0)^2/2! f''(t_0) + ... + (t-t_0)^n/n! f^(n) (t_0) + o((t-t_0)^n) $

Geometrically, we have $arrow(f(t_0)f(t)) = f(t) - f(t_0) =  ((t-t_0))f'(t_0)$.
Thus, when it does not vanish, $f'(t_0)$ is tangent to $cal(C) = f([a,b]) $ at $f(t_0)$.


Now, let $p$ be the smallest $k >= 1$ such that $f^(k) (t_0) != 0$ and $q$ the smallest $k > p$ such that $(f^(p)(t_0), f^(q)(t_0))$ are linearly independant.

Then, in the reference frame centered around $f(t_0)$ and with basis vectors $(f^(p)(t_0), f^(q)(t_0))$, we have $ f(t) approx vec(lambda (t) , mu (t)) "where" lambda (t) = (t-t_0)^p/p! "and" mu (t) = (t-t_0)^q / q!. $


TODO : Add figure

* Remark : * In practice, $lambda (t) > > mu(t)$, thus the influence of $f^q$ is vastly exaggerated in the figure.

== Metric properties of curves

=== Length of a rectifiable curve
In this section $ norm(.)$ is implicitely assumed to be the euclidean norm $norm(.)_2$.

Let's first define the length of a curve in the most geometrical way possible.
#definition("Length of a rectifiable curve")[

  Let $gamma : [a,b ] -> RR^d$ be $cal(C^k)$ with $k>=1$, and $cal(S)$ be the set of uniform subdivisions of $[a,b]$. For $s =  (t_0, t_1, dots , t_n) in cal(S)$, we define $ l(s) = sum_(i=0)^(n-1) norm(gamma (t_(i+1)) - gamma(t_i)). $

  If ${l(s), s in cal(S)}$ is bounded, we say $gamma$ is *rectifiable* and define the length $L(gamma)$ of $gamma$ as $ L(gamma) = sup_(s in cal(S) ) l(s) $

  

  
]

This leads to the natural integral caracterisation that follows.
#theorem("Integral expression of the length of a rectifiable curve")[
  Let $gamma: [a,b] -> RR^d $ be a rectifiable curve.
  We have :
 $ L(gamma) = integral_(a)^(b) norm(gamma '(t))d t  $

 
]

=== Arc-length

#definition("Arc-length of a rectifiable curve")[
  Let 
]



=== Notion of regular curve

#definition("Regular Curve")[
  A curve $gamma : I subset RR -> RR^d$ of class $cal(C)^k$ is said to be regular at $t$ if $gamma'(t) eq.not 0.$
]
*Remarks*: 
- A $cal(C)^1$ regular curve admits a tangent at every point
- We sometimes call the set $tilde(C) = gamma(I) subset RR^d$ the "geometric curve" or the support of the curve.
- For $cal(C)^1$ regular curves, $I$ is connected/compact $=>$ $tilde(C)$ is connected/compact

#example("A non regular smooth curve")[

Consider the following $cal(C)^0$ curve :

$ t -> cases(
    (t,t^(3/2)) "if" t>= 0,
    (abs(t) - abs(t)^(3/2)) "else"
     
) $

#figure(
  image("figures/ex1.png", width: auto, height:20%),
  caption: [The geometric curve],
) <fimg-label>

This geometric curve can be represented by the map $g : t -> (t^2, t^3)$ which is $cal(C)^(infinity)$. The curve is not regular in $0$ because $g'(0) = 0$.
]




#proposition("Reparametrization")[
Let $gamma : I subset RR -> RR^d$ and $phi : I -> J$ a $cal(C)^k$ diffeomorphism (i.e $phi$ bijective, $phi$ of class $cal(C)^k$, $phi'(t) eq.not 0$, thus $phi^(-1)$ is of class $cal(C)^k$).

  Then $gamma compose phi^(-1) : J -> RR^d $ is called an admissible reparametrization of $gamma$ and $phi$ or $phi^(-1)$ is called an admissible change of variable.
]
*Remark*:  $phi(t) = t^3 $ is not an admissible change of variable, because $phi'(0) = 0 $, even tho $phi$ is bijective and $cal(C)^k$.


We sometimes also see the following alternative definition of geometric curve, which states that a geometric curve does not depend on the parametrization.

#definition("Geometric Curve")[
A "geometric curve" is an equivalence class for the relation $ gamma : I -> RR^d ~ g: J -> RR^d  "if" exists phi: J -> I " a " cal(C^k)"-diffeomorphism s.t" gamma = g compose phi^(-1) . $


]

#proposition()[
  If $gamma: I -> RR^d$ is $cal(C)^k$ regular and $phi : J -> I$ is an admissible change of variable, then $gamma compose phi$ is $cal(C^k)$ regular.

  
]
#proof[
  $(gamma compose phi)'(t) = gamma'(phi(t)) dot phi'(t) eq.not 0$
]

* Remark * : Non-admissible reparametrization exist and can change the regularity of the curve, but not the admissible ones.


== Plane curves
We will now study the curvature of plane  and space curves separately, starting with plane curves.


#definition("Serret-Fresnet frame")[

  Let $gamma : I -> RR^2$ a $cal(C)^1$ regular curve. The frame $(f(s), T(s), N(s))$ is called the Serret-Fresnet frame at $t$.

]

* Remark * : When the curve is parametrized with arc-length, $T(s) = gamma'(s)$, thus $N(s) = op("Rot")_(pi/2)(gamma'(s)).$
=== Curvature
#definition("Curvature for plane curves")[
Let $gamma : I -> RR^2$ a $cal(C)^2$ regular curve parametrized by arc length. The curvature of $gamma$ at $gamma(s)$ is defined by
  $ kappa_s (s) = angle.l gamma''(s), N(s) angle.r = plus.minus norm(gamma''(s)) $
]
* Remark * : 
- We define curvature to be positive when $gamma''(s) = N(s) $ and negative when $gamma''(s) = -N(s).$ This can be interpreted by convexity $<=>$ positive curvature for graphs of $RR -> RR$ functions. 
- For any non arc-length parametrization, $gamma''(t)$ is not (in general) orthogonal to $gamma'(t)$ and the above formula doesn't hold. It still holds if $norm(gamma'(t))$ is constant as $T(t) = (gamma'(t))/norm(gamma'(t))$. We can however derive a general formula for any parametrization.

#proposition("Planar curvature for general parametrizations")[
  Let $gamma : I -> RR^2$ a $cal(C)^2$ regular curve. We have
  $ kappa_t (t) = (det (gamma'(t), gamma''(t)))/norm(gamma'(t))^3 $
]

#let tgm = $tilde(gamma)$
#proof[
Let $tgm = gamma compose phi^(-1)$ be the arc-length reparametrization of $gamma$. We denote $t = phi^(-1)(s)$. Then,
  $ tgm'(s) = (gamma compose phi^(-1))'(s) = gamma'(phi^(-1)(s)) dot (phi^(-1))'(s) = (gamma'(t))/norm(gamma'(t)).  $
Hence $ tgm''(s) = (gamma''(t))/norm(gamma'(t))^2 + gamma'(t) d/(d t)(1/norm(gamma'(t))) \
  =>  det (tgm'(s), tgm''(s)) = (det (gamma'(t), gamma''(t)))/norm(gamma'(s))^3. $
 Indeed, $gamma'(t) d/(d t)(1/norm(gamma'(t)))$ is colinear to $gamma'(t)$ and thus vanishes in the $det$.
 Furthermore, since $kappa(s) = angle.l tgm''(s), N(s) angle.r$ and $tgm''(s)$ is colinear to $N(s)$, we have $det(tgm'(s), tgm''(s)) = det(T(s), kappa_s (s)N(s)).$ Thus, since $(T(s), N(s))$ is a direct basis, $det(T(s), N(s)) = 1$, hence $det(T(s), k(s)N(s)) = kappa_s (s).$ Finally,$ kappa_s (s) = kappa_t (t) = det (tgm'(s), tgm''(s)) = (det (gamma'(t), gamma''(t)))/norm(gamma'(s))^3. $
]

#proposition("Serret-Fresnet formula")[
  Let $gamma : I -> RR^2$ a $cal(C)^2$ regular curve parametrized by arc length. We have

  $ cases(
      T'(s) = kappa(s)N(s),
      N'(s) = -kappa(s)T(s)
  )  $

]
#proof[
- TODO
- We have $angle.l N(s), T(s) angle.r = 0.$ Differentating this equation yields $ angle.l N'(s), T(s) angle.r + underbrace((angle.l N(s), T'(s) angle.r), kappa(s)) = 0 . $ Moreover, $ angle.l N(s), N(s) angle.r = 1 => angle.l N'(s), N(s) angle.r = 0. $

  Thus, in the direct basis $(T(s), N(s))$, we have $N'(s) = vec(-kappa(s), 0)$, i.e $N'(s) = -kappa(s)T(s).$
]
=== Osculating circle and center of curvature
#definition("Center and radius of curvature")[
  Let $gamma: I -> RR^2$ a $cal(C)^2$ regular curve. For all $t$ where $kappa(t) eq.not 0$, we define the center of curvature $c(t)$ as
  $ c(t) = f(t) + 1/kappa(t) N(t). $

  The quantity $display(R(t) = 1/norm(kappa(t)))$ is called the radius of curvature.
]

* Remark * :
- The circle of center $c(t)$ and radius $R(t)$ is called the osculating circle to $gamma$ at $gamma(t)$.
- The osculating circle is placed towards the (local) interior of the curve : this justifies the sign convention in the curvature definition.

#proposition("Osculating circle approximation")[
  The osculating circle to $gamma$ at $gamma(t)$ is tangent to $cal(C)(gamma)$ at $gamma(t)$ and approaches $gamma$ at order $2$ around it.
]

#proof[ Admitted.]
=== Total curvature

#proposition("Total curvature")[

  Let $gamma : [a,b] -> RR^2$ a $cal(C)^2$-regular curve parametrized by arc-length. We have 

  $ integral_(a)^(b) k(s)d s = theta(b,a) (:= "total angle variation of " gamma )  $

This quantity is called total curvature.
]

#proof[
  

We denote $display(f(s) = vec(x(s), y(s)))$ and $theta(s) = (O_x, T(s))$ the angle between the tangent vector to $f$ and the $x$-axis.
  We define $theta$ to be differentiable thus continuous, thus defined up to $2pi k$.
  Then, $ T(s) = vec(cos theta (s), sin theta(s)) quad "and" quad N(s) = vec(-sin theta (s), cos theta (s)). $

  Hence,
  $ T'(s) = theta '(s) vec(-sin theta (s), cos theta (s)) quad "and" quad T'(s) = k(s)N(s). $

  This yields:
  $ theta '(s) = k(s) $

  And the conclusion trivially follows.

  

  

  
]


== Space curves

In this section, we let $gamma : I subset RR -> RR^3$  be a $cal(C)^k$ regular space curve ($k$ will be specified).

=== Principal normal vector and curvature

#definition("Space curvature")[
If $gamma$, $cal(C)^2$ regular, is parametrized by arc-length, the curvature $kappa$ is defined by:

  $ kappa(s) = norm(gamma''(s)). $
]
* Remark * : Space curvature is unsigned, due to the fact there is no unique normal vector to the curve, but a plane.

#proposition("Space curvature for general parametrizations")[
  For any regular parametrization of $gamma$, we have
  $ kappa(t) = norm( gamma'(t) and gamma''(t))/norm(gamma'(t))^3.  $
]
#proof[
  We denote $tgm = gamma compose phi^(-1)$ the arc-length parametrization of $gamma$, with $t = phi^(-1)(s)$.
  We have $ angle.l tgm'(s), tgm'(s) angle.r = 1 ==> 2 angle.l tgm''(s), tgm'(s) angle.r = 0 & \ ==> tgm''(s) perp tgm'(s) quad "and" quad norm(tgm'(s) = 1) & \ ==> kappa(s) = norm(tgm''(s)) = norm(tgm'''(s) and tgm'(s)).  $

  We already derived in 2D (same proof works) that
  $ tgm''(s) = (gamma''(t))/(norm(gamma''(t))) + gamma'(t) dot d/(d s) (1/norm(gamma'(t))).  $
  Hence,
  $ kappa_s (s) = norm( (gamma''(t))/(norm(gamma'(t))^2)+ gamma'(t) dot lambda(t) and (gamma'(t))/norm(gamma'(t)))= norm(gamma''(t) and gamma'(t))/norm(gamma'(t))^3 :=k_t (t) . $ 
 
]


#definition("Principal normal vector")[
  If $gamma$ is $cal(C)^2$ regular and parametrized by arc-length, when $kappa(s) eq.not 0$, i.e $gamma''(s) eq.not 0$, we define the principal normal as
  $ N(s) = (gamma''(s))/norm(gamma''(s)) = (1/kappa(s) d/(d s)T(s)) $
  Where:
  - $T(s) = gamma'(s)$ is a tangent vector
  - $gamma$ is said to be biregular if $forall s, gamma''(s) eq.not 0.$
]
* Remark *:
- The term *principal* comes from the fact that when you perform a Taylor expansion of $gamma$ around $s$, the curve lies (at order $2$) in the $(T(s), N(s))$ plane, since $N(s)$ is defined through $gamma''(s) perp T(s) = gamma'(s)$.
- We can also express the principal normal using a non-arc length parametrization.
- The principal normal and the planar normal vector are the same up to the sign. Thus, the principal normal is not continuous in general. Indeed, it can change orientation instantly on inflexion points.

#definition("Osculating plane/sphere, radius and center of curvature, evolute")[

  - The osculating plane at point $gamma(t)$ is the plane spanned bt $T(t)$ and $N(t)$.
  - The radius of curvature is $R(t) = 1/(kappa(t))$.
  - The center of curvature is $c(t) = f(t) + R(t)N(t).$
  - The evolute is the set of centers of curvatures.
  - The osculating sphere at point $gamma(t)$ is $cal(S)(C(t),R(t)).$
  - The osculating circle is the osculating sphere's cut through the osculating plane.
]

#definition("Binormal vector and Serret-Fresnet frame")[
  If $gamma$ is $cal(C)^2$ regular and arc-length parametrized and $s$ is a biregular point of $gamma$, then we define

  - $B(s) = T(s) and N(s)$ the binormal vector at $gamma(s)$.
  - $gamma(s), T(s), N(s), B(s)$ the Serret-Fresnet frame.
]

Another interesting property of $gamma$ is encoded by the variation of the osculating plane, that we call torsion. This can be defined using the derivative of the binormal vector, which is orthogonal to the osculating plane. This requires $gamma$ to be $cal(C)^3$ regular.

#proposition[
  If $gamma$ is $cal(C)^3$ regular and arc-length parametrized, then $B'(s)$ is colinear to $N(s)$.
]
#proof[

  *First method *:
  $norm(B(s))^2 = angle.l B(s), B(s) angle.r = 1 ==> B'(s) perp B(s).$ Hence, since $B(s) perp N(s)$, $B'(s)$ is colinear to $N(s).$ 
  *Second method* : Differentiating $B(s)$ using the product rule yields:
   $ B(s) = T(s) and N(s) & ==> B'(s) = underbrace(T'(s) and N(s), 0) + T(s) and N'(s) = T(s) and N'(s) \ & ==> B'(s) perp T(s) \ & ==> B'(s) "is colinear to" N(s). $

   
]

#definition("Torsion")[For $gamma$ a $cal(C)^3$ regular space curve parametrized by arc-length, we define torsion of $gamma$ in the point $gamma(s)$ for all biregular points $s$ as
$ tau(s) = -angle.l B'(s), N(s) angle.r = plus.minus norm(B'(s)) $
]
* Remark * : 
- Torsion measures the speed of rotation of the binormal vector at the given point.  It's sign informs on the direction of rotation : the negative sign in the definition is a matter of convention. We thus define torsion to be negative when in the direction of the normal vector, and negative in the opposite case.
- As $N(s)$ is colinear to $B'(s)$, this is equivalent to $ B'(s) = -tau(s)N(s).$
- As $N(s) perp B(s)$, this is also equivalent to $angle.l N'(s), B(s) angle.r$.



#proposition("Torsion formula for arc-length parametrized curves")[
  For $gamma$ a $cal(C)^3$ regular space curve parametrized by arc-length, we have $ tau(s) = det(gamma'(s), gamma''(s), gamma'''(s)) / norm(gamma''(s))^2 . $
]

#proof[
  $ tau(s) & =  - angle.l N(s), B'(s) angle.r  \ & =  T O D O  $
 
  Thus $tau(s) = det (T(s), N(s), N'(s))$. However, $ & dot T(s) = gamma'(s) \ & dot N(s) = R(s) gamma''(s) \ & dot N'(s) = R'(s)gamma''(s) + R(s)gamma'''(s)  $

  Hence, $ tau(s) & = det( gamma'(s), R(s)gamma''(s), R'(s)gamma''(s) + R(s)gamma'''(s)) \ & = R(s)^2 det (gamma'(s), gamma''(s), gamma'''(s)). $

  The conclusion trivially follows.

  
]



#proposition("Torsion formula for general biregular parametrization")[

 For $gamma$ a $cal(C)^3$ regular space curve parametrized by $t$, we have $ tau(t) = det(gamma'(t), gamma''(t), gamma'''(t)) / norm(gamma'(t) and gamma''(t))^2 $
]

#proof[ Admitted.]


#proposition("Geometric interpretation of vanishing torsion")[
Let $gamma$ be a $cal(C)^3$ biregular space curve. We have :
  $ gamma "is planar" <=> tau eq.triple 0. $
]

#proof[
 - $ gamma "is planar" ==> gamma', gamma'' "and" gamma''' "are coplanar" ==>  tau eq.triple 0.  $
- Suppose $tau eq.triple 0$, i.e $B(s) eq.triple B_0$ (parametrizing $gamma$ by arc-length). Then $forall s$, 
  $  (angle.l gamma(s), B_0 angle.r)' = angle.l gamma'(s), B_0  angle.r = angle.l T(s), B_0 angle.r = 0. $

 This tells us that $angle.l gamma(s), B_0 angle.r $ is constant, thus $gamma(s)$ lies in a plane orthogonal to $B_0$.

  
]

#proposition("Serret-Fresnet formula")[
  Let $gamma$ be a arc-length $cal(C^3)$ parametrized space curve. We have
  - $T'(s) = kappa(s)N(s)$
  - $B'(s) = - tau(s)N(s)$
  - $N'(s) = -kappa(s)T(s) + tau(s)B(s)$.

]

#proof[
 First two points were already proven earlier.
  - $(norm(N(s))) = 1 => N' perp N$. Since $(T(s),B(s))$ is thus a direct basis, we have $N'(s) = lambda(s)T(s) + mu(s)B(s)$. We have

    $  lambda(s) = angle.l N'(s), T(s) angle.r
               = - angle.l N(s), T'(s) angle.r
               = - angle.l N(s), kappa(s)N(s) angle.r
               = - kappa(s).
    $
   And 
  $ mu(s) = angle.l N'(s), B(s) angle.r = - angle.l N(s), B'(s) angle.r = - angle.l N(s), -tau(s)N(s) = tau(s). $ 
]

#theorem("Fundamental theorem of local theory of curves
")[

  Let $kappa : [a,b] mapsto RR $ and $tau : [a,b] mapsto RR$ be $cal(C)^1$ functions, and such that $kappa$ is always strictly positive.

  Then, there exists a unique (up to a rigid motion) $cal(C)^3$ arc-length parametrized curve $gamma : [a,b] mapsto RR^3$ whose curvature is $kappa$ and torsion $tau$. ]

#proof[
  Admitted. Relies on Cauchy-Lipschitz.
]


= Differential geometry of surfaces

Representations of surfaces include : 
- Parametrization : $f : U subset RR^2 mapsto RR^3$
 - Special case : the graph of a map $phi : RR^2 mapsto RR$ is $f(x,y,z) = (x,y, phi(x,y))$.
- Implicit : An inverse image of a map $g : RR^3 mapsto RR$. 
  - Example : Let $g(x,y,z) = x^2 + y^2 + z^2 - R^2$. Then $g^(-1)({0})  "is the sphere of center" 0_(RR^3) "and radius" R.$
- Drawings !

These representations are locally equivalent when surfaces are "regular" (existence of tangent spaces).

In the following section, $U$ and $V$ are taken to be open sets of $RR^2$. 

== Generalities

#definition("Parametrized surface")[
  A $cal(C)^k$ parametrized surface is a $cal(C^k)$ map $f: U subset RR^2 mapsto RR^3$.
]


We are interested in the geometric surface $ S = f(U)$. However, one such geometric surface can admit many different parametrizations. They are all the same up to a diffeomorphism. More precisely, with $phi$ a $C^(k)$ diffeomorphism, we have: 


#align(center)[#diagram(cell-size: 15mm, $
	U subset RR^2 edge(f, ->) edge("d", phi, ->) & S \
	V subset RR^2 edge("ur", g, "->")
$)]

#definition("Admissible change of variable ")[

  We say $phi : U mapsto V$ is an admissible change of variable for a $cal(C^(k))$ parametrized surface if $phi$ is a $cal(C^k)$ diffeomorphism. The induced reparametrization is $g  = f compose phi^(-1).$ Indeed, $ g(V) = f(phi^(-1)(V)) = f(U). $
]

We are interested in *geometric* properties of curves, thus that do not depend on reparametrization by an admissible change of variable.

== Tangent spaces


#definition("Curve on surface")[
Let $f : U mapsto RR^3$ be a $cal(C^1)$ surface and $gamma : I subset RR mapsto U$ a $cal(C^1)$ curve. 
  Then, $f compose gamma $ is a curve on $S = f(U)$.
]

*Examples*:
Let $I_1,I_2 subset RR$ such that $I_1 times I_2 subset U$. For any point $(u_0,v_0) in I_1 times I_2$, we define the *coordinate curves* on $S$ as $gamma_(u_0) : I_1 mapsto S$ and $gamma_(v_0) : I_2 mapsto S$ :
$ gamma_(u_0) : v mapsto  gamma(u_0, v) quad "and" quad gamma_(v_0) : u mapsto gamma(u, v_0). $



Remark that $gamma'_(u_0)(v_0) = dvp(f,v)(u_0, v_0) $ and $gamma'_(v_0)(u_0) = dvp(f,u)(u_0,v_0)$.


#definition("Tangent space")[

The tangent space to $S = f(U)$ as $m_0 = f(u_0,v_0)$ is the affine space passing through $m_0$ and spanned by $(dvp(f,u)(u_0,v_0), dvp(f,v)(u_0,v_0))$. We denote it $T_(m_0) S.$
]
*Remark* : We will often abusively refer to $T_(m_0)S$ as a vector space, omitting the translation from $0$ to $m_0$.


#proposition[$T_(m_0)S $ is (as a vector space) the set of derivatives of parametrized curves on $S$ at $0$ where $C(0) = m_0$.]

#proof[

  Let $C = f compose gamma$ be a curve on $S$.
  Then $C'(t) = D_f (gamma(t)) dot gamma'(t).$ We set $gamma(0) = (u_0,v_0)$ and $gamma'(0) = (lambda, mu)$.
  Then, $ C'(0) = D_f (u_0,v_0) dot (lambda, mu) = dvp(f,u)(u_0,v_0) lambda + dvp(f,v)(u_0,v_0)mu in T_(m_0)S. $

  For the reciprocal inclusion, let $X in T_(m_0)S.$ We know

  $ exists (lambda, mu) in RR², space X = dvp(f,u)(u_0,v_0) lambda + dvp(f,v)(u_0,v_0)mu. $

  We thus pick a curve $gamma : I subset R mapsto U$ such that $gamma(0) = (u_0,v_0)$ and $gamma'(0) = (lambda , mu).$ We denote $C = f compose gamma$.

  Then $X = D_f (u_0,v_0) dot (lambda, mu) = C'(0).$

  
]
*Remarks* :
- We can express the tangent space (as a vector space) as  $T_(m_0)S = op("Im")(D_f (u_0, v_0))$. 
- A parametrized surface $f$ is regular at $m_0$ if $op("Rank")(D_f (u_0, v_0)) = 2$, i.e the tangent space is a *plane*.
- A parametrized surface $f$ is said to be regular if it is regular at every point.
- A geometric surface $S$ is said to be regular if there exists a regular paramerization of $S$.

#proposition("Invariance of regularity of surfaces by reparametrization")[
  Let $f : U mapsto RR^3$ be a $cal(C)^(1)$ regular parametrized surface and $g : V mapsto RR^3$ a reparametrization of $f$. 

  Then, $g$ is regular and the tangent spaces coincide.
]

#proof[

#align(center)[#diagram(cell-size: 15mm, $
	U subset RR^2 edge(f, ->) edge("d", phi, ->) & S subset RR^3 \
	V subset RR^2 edge("ur", g, "->")
$)]

We have $f = g compose phi $. Thus, $ D_f (u_0,v_0) = D_g ( phi(u_0,v_0)) compose D_(phi) (u_0,v_0) quad "where" quad D_phi (u_0,v_0) : RR^2 mapsto RR^2 "is an isomorphism." $
  Hence, $ op("Im")(D_f (u_0,v_0)) = op("Im")(D_g (u_0,v_0)). $

  It trivially follows that $g$ is regular if and only if $f$ is.

]

== Metric properties

=== First fundamental form

#definition("First fundamental form")[
  Let $f : U subset RR^2 mapsto RR^3$ be a $cal(C)^1$-regular surface.
  The first fundamental form is defined by :

  $ i_(m_0) : & T_(m_0)S times T_(m_0)S mapsto RR \ &
  (x,y) --> angle.l x, y angle.r $
  
]
*Remark*: 
- Since $f$ is regular, the first fundamental form is canonically identified to a $2D$ dot product on $T_(m_0)S$ via change of basis. This justifies focusing on the expression of the first fundamental form in this basis.
- The first fundamental form is a dot product, i.e a positive definite symmetric bilinear form. Our notations will thus be based on the matrix expression of bilinear form

#proposition("Matrix of the first fundamental form in the tangent space basis")[
  We can express the first fundamental form in the basis $(dvp(f,u)(u_0,v_0), dvp(f,v)(u_0,v_0)) = (U,V) $ of $T_(m_0)S$ by the following matrix:
  $ I_(m_0) = mat( E_(m_0), F_(m_0) ;
    F_(m_0), G_(m_0) ) $
  #linebreak() Where $E_(m_0) = angle.l U, U angle.r$, $F_(m_0) = angle.l U, V angle.r $ and $G_(m_0) = angle.l V, V angle.r .$
] <propmatfirst>
#proof[
Let $X = vec(x_u, x_v)$ and $Y = vec(y_u, y_v)$ be two tangent vectors expressed in the given basis. We have
  $ i_(m_0) (X,Y) & = angle.l x_u U + x_v V, y_u U + y_v V angle.r \ & 
  = x_u y_u angle.l U, U angle.r + (x_u y_v + x_v y_u) angle.l U, V angle.r + x_v y_v angle.l V, V angle.r \ &
  = X^T I_(m_0) Y. $

  
]


*Remark* : 
- From a differential geometry point of view, $I_(m_0)$ as a matrix amounts to a pull back of the dot product on the parameter space.
- We usually like to represent bilinear forms in orthornormal bases, beware that it is not the case in general for the tangent space basis.


#proposition("Local area multiplicative factor expressed by the fundamental form")[
  We have $ norm( dvp(f,u)(u_0,v_0) and dvp(f,v)(u_0,v_0)) = sqrt(det(I_(m_0))) = sqrt(E_(m_0)G_(m_0) - F_(m_0)^2). $
] <propdet> 

#proof[
Let $u, v in RR^3$. We have $ norm(u and v)^2 = norm(u)²norm(v)^2 sin (u,v)^2 quad "and" quad bar angle.l u, v angle.r bar^2 = norm(u)^2 norm(v)^2 cos(u,v). $   
  Thus, $norm(u and v )^2 = norm(u)^2 norm(v)^2 - angle.l u, v angle.r ^2.$
 
  Conclusion trivially follows using $(u,v) = (dvp(f,u)(u_0,v_0), dvp(f,v)(u_0,v_0)).$
]


*Remark* : Since $I_(m_0)$ is a positive bilinear form, $det(I_(m_0)) > 0.$


=== Length of a curve on a surface

#proposition("Length of a curve on a surface")[Let $gamma : [a,b] mapsto U$ defined by $gamma(t) = vec(u(t), v(t))$ and $f : U mapsto RR^3$. Denote $C_gamma = f compose gamma$ and $l(C_gamma)$ the length of $C$. We have 

$ l(C_gamma) = integral_(a)^(b) sqrt(I_((f compose gamma)(t)) (gamma'(t), gamma''(t))) d t $]


#proof[ We have $ l(C_gamma) = l( f compose phi)  
= integral_(a)^(b) norm( (f compose gamma)'(t)) d t  . $

Also, 
$ norm((f compose gamma)'(t))^2 & = norm(D_f (gamma(t)) compose D_gamma (t)))^2 \ & 
= norm( dvp(f,u)(u(t), v(t)) dot u'(t) + dvp(f,v)(u(t), v(t) dot v'(t)  ) )^2 \ & 
= u'(t)^2 underbrace(norm(dvp(f,u)(u(t),v(t)))^2, E) + 2 dot u'(t)v'(t) angle.l underbrace(dvp(f,u)(u(t), v(t)), F) angle.r  + v'(t)^2 underbrace(norm( dvp(f,v)(u(t), v(t)))^2, G) \ &
= I_(gamma(t))(gamma'(t), gamma''(t)). $

This yields the wanted formula.
]


#proposition("Area of a surface")[

Let $f : U mapsto RR$ be a $cal(C)^1$ regular surface. The area of the surface $S$ is the following (independent of parametrization) quantity :

  $ A(S) = integral_(U)^() sqrt( det (I_f (u,v))) d u d v.  $
]
#proof[ Admitted, although it is just an application of @propdet to the integral definition of the area of a surface. See #link("https://fr.wikipedia.org/wiki/Int%C3%A9grale_de_surface", "here") for details..]



== Curvature

=== Differentiable map between surfaces

We want to give a meaning to the differential of a map $phi$ between surfaces. More precisely, consider the following diagram :


#align(center)[#diagram(cell-size: 15mm, $
	S_1 subset RR^3 edge(phi, ->) edge("d",f, <-) & S_2 subset RR^3 \
      U subset RR^2 & V subset RR^2 edge("u", g, ->)
$)]

Our goal is to build a linear map that locally represents $phi$.

#definition("Differentiable map between surfaces")[
  We say that $ phi : S_1 mapsto S_2$ is differentibale if $f compose phi compose phi^(-1)$ is differentiable. 

  It's differential $d phi (m_0) :  T_(m_0)S_1 mapsto T_(m_1)S_2$ is then defined for every $X in T_(m_0)S_1$ as
  
$ d phi (m_0) := d( phi compose f)(u_0,v_0)(h,k) in T_(m_0)S_2 "where" (h,k) in RR^2 "is a vector s.t" X = d f (u_0,v_0) dot (h,k). $
]
*Remark:* We denote $D phi (m_0)$ the matrix of the differential in the basis $(dvp(f,u)(u_0,v_0), dvp(f,v)(u_0,v_0)) = cal(B).$
=== Gauss map and second fundamental form

Let $f: U mapsto RR$ be a $cal(C)^2$ regular surface and $m_0 = f(u_0, v_0) in S.$ The vector 
$ N(u_0,v_0) = (dvp(f,u)(u_0,v_0) and dvp(f, v) (u_,v_0))/ norm(dvp(f,u)(u_0,v_0) and dvp(f, v) (u_,v_0)) $
is a unit vector orthogonal to $T_(m_0)S.$

#proposition[The line $op("Span")(N_f(u_0,v_0))$ does not depend on the parametrization of $S = f(U)$.]

#proof[
  Let $g : V mapsto RR^3 $ be a reparametrization of $S$, $f = g compose phi$.
  A few lines of algebra yield:

  $ N_f (u_0,v_0) = N_g (phi(u_0,v_0)) dot (det(D_phi (u_0,v_0)))/abs(det(D_phi (u_0,v_0))). $

  Thus $N_f(u_0,v_0)$ is defined up to the sign, hence the span is invariant. Note that this sign is constant since $phi$ is a diffeomorphism.
]

#definition("Orientable surface")[
  We say that a surface $S$ is orientable if there exists a continuous unit normal vector on $S$.
]
*Remark*:
- Orientability is a global notion.
- An orientable surface thus has a defined inside and outside based on this normal vector.
- The Moebius strip is non orientable.

#let Kt = $tilde(K)$
#definition("Gauss map")[
  Let $S$ be a $cal(C)^2$-regular orientable surface of $RR^3$ and $SS^2$ the unit sphere of $RR^3$. We define the continuous map :

  $ K & : S --> SS^2 \ &
  m_0 --> K(m_0) $

Where $K(m_0)$ is the unit normal vector to $f$ in $m_0$. $K$ is called the Gauss map.
  
]
*Remark* : We denote $Kt = K compose f$ the Gauss map with respect to $U$.
#proposition("Differential of the Gauss map")[The map
$d K(m_0) : T_(m_0)S --> T_(K(m_0)) SS^2$ is a self-adjoint endomorphism.]

#proof[
As done previously, we identify the tangent spaces to vector spaces.
- $d K (m_0)$ is obviously linear.  TODO : endo proof
- TODO (photos)
]


This is an important property of the gauss map. Indeed, by the spectral theorem, $d K(m_0)$ is orthornomally diagonalizable  and the eigenvalues $lambda_1 < lambda_2$ satisfy $ lambda_1 = min_(x in (RR^2)^(*)) angle.l D K (m_0)x , x angle.r  "and" lambda_2 = max_(x in (RR^2)^(*)) angle.l D K (m_0)x , x angle.r.  $ 

This leads to the following definitions:

#definition("Principal curvatures")[
  - The eigenvectors of $d K(m_0)$ are called the principal directions od $S$ at $m_0$, and the eigenvalues the principal curvatures
  - The quantiy $G(m_0) = det(d K(m_0)) = lambda_1 lambda_2$ is called the Gauss curvature.
  - The quantiy $H(m_0) = (op("Tr")(d K (m_0)))/2 = (lambda_1 + lambda_2)/2$ is called the mean curvature.
  - The operator $a_(m_0) = - d K (m_0)$ is called the Weingarten endomorphism.

]

We now define the second fundamental form of a surface and link it to the Weingarten endomorphism for computation purposes.

#let ii = $I I$
#definition("Second fundamental form")[
Let $f : U subset RR^2 mapsto RR^3$ be a $cal(C)^2$-regular surface and $m_0 = f(u,v)$ where $(u,v) in U$. 

The second fundamental form is defined by :

  $ i i_m &: T_m S times T_m S --> RR  \ & (X,Y) --> angle.l - D K (m)X, Y angle.r $
]
*Remark* : $i i _m (X,Y) = i_m (- d K (m)X, Y).$


#let d2(f,u) = $dvp(f,u,deg: 2)$
#proposition("Matrix expression of the second fundamental form")[
  We denote $Kt = K compose f$ the Gauss map expressed in terms of parameters in $U$. We can express the first fundamental form in $ cal(B)$ of $T_(m_0)S$ by the following matrix:

  $ ii_(m_0) = mat( L_(m_0), M_(m_0); M_(m_0), N_(m_0)) $

  where $ L_(m_0) & = angle.l d2(f,u), Kt(u,v) angle.r \ M_(m_0) & = angle.l dvp(f,u,v) (u,v), Kt(u,v) angle.r \ N_(m_0) &= angle.l dvp(f,v,deg:2), Kt(u,v) angle.r . $
]

#proof[
Computations analog to proof of @propmatfirst .
]

#proposition("Matrix expression of the Weingarten endomorphism ")[
  The matrix of $a_(m_0) = - d K (m_0)$ in $cal(B) $ is $ A_(m_0) = I_(m_0)^(-1)ii_(m_0). $
]

#proof[

  We know $i i _(m_0) (X,Y) = i_m (- d K (m_0)X, Y) = i_m (a_m (X),Y)$. In $cal(B)$, this is be written as

  $ X^T ii_(m_0)Y = (A_(m_0)X)^T I_(m_0) Y = X^T A_(m_0)^T I_(m_0) Y ==> ii_(m_0) = A^T_(m_0)I_(m_0). $

  Since $i i _(m_0)$ and $i_(m_0)$ are symmetric, we thus have $ii_(m_0) = I_(m_0)^T A_(m_0) = I_(m_0)A_(m_0).$

  Finally, $I_(m_0)$ is invertible because it is the matrix of a positive bilinear form, which yields
  $ A_(m_0) = I_(m_0)^(-1)ii_(m_0)$.
]



