#import "template.typ": project, chapter

#show: project.with(
  title: "Convex Optimization",
  author: "ZTS",
  email: "plote5024@gmail.com",
)

#chapter("Recommended Books")

#align(center)[
  #set par(justify: true)
  Boyd. Vandenberghe.  《 Convex Optimization 》\
  Nocedal. Wright.  《 Numerical Optimization  >\
  Nesterow. 《 Introductory Lectures On Convex Optimization 》
]

#chapter("Convex Set")

= 凸集与凸函数
#v(.9em)
$ C subset.eq RR^n$,$C$ is Convex

$ alpha x + (1 - alpha)y in C, quad forall x,y in C, quad forall alpha in [0,1] $

#v(.9em)

Convex Hull
$ S subset RR^n, quad "conv"(S) = {alpha x + (1 - alpha)y : x in S, y in S, 0 < alpha < 1} $

#v(.9em)

#figure(
  image("../../img/convex .png", width:70%),
  caption: [凸集的定义.:凸集中任意两点的连线线段都包含在集合内部，因此左图中的集合是凸集，而右图中的不是.
  ],
) 

#v(.9em)
== prove
#v(.9em)

+ ${x:A x = b }$
  $ A x=b, A y = b  →  A(alpha x +(1-alpha)y) = (alpha+(1-alpha))b = b $
+ ${x:A x subset.eq b}$
  
  $ A (alpha x+(1-alpha)y) = alpha A x+(1-alpha)A y subset.eq b$

+ ${x:norm(x)_2^2  \u{2A7D} 1 }$
  
  $norm(alpha x+(1-alpha)y)_2^2 \u{2A7D}   alpha^2norm(x)^2+(1-alpha)^2norm(y)^2+2alpha(1-alpha)X^T y
  $

  $ \u{2A7D} alpha^2 norm(x)^2 + (1 - alpha)^2 norm(y)^2+2alpha(1-alpha) norm(x)norm(y)$
  
  $ = (alpha norm(x)+(1-alpha)norm(y))^2$
  
  $\u{2A7D}(alpha+(1-alpha))^2 = 1$