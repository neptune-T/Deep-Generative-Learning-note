#import "@preview/red-agora:0.1.1": project

#show: project.with(
  title: "Measure Theory",
  subtitle: "Note for self",
  authors: (
    "Plote",
  ),
  mentors: (
    "MIRA(book)",
    "Measure Theory -- Terence Tao"
  ),
  
  branch: "math/Measure Theory",
  academic-year: "2025-1-20"
)

= Riemann Integration


== Review: Riemann Integral

We begin with a few definitions needed before we can define the Riemann integral.
Let R denote the complete ordered field of real numbers.(设R表示实数的完整有序字段)


#let definition(number: none, term: none, content) = {
  let header-fill = rgb("#bde6f1") 
  
  box(
    width: 100%,
    fill: header-fill,
    radius: 5pt,
    stroke: black,
    [
      #pad(
        x: 10pt,
        y: 8pt,
        [
          #text(weight: "regular")[#number #h(2pt) Definition #h(2pt)] 
          #if term != none {
            text(style: "italic")[#term]
          }
          
          #pad(top: 5pt)[
            #content
          ]
        ]
      )
    ]
  )
}



#let example(number: none, term: none, content) = {
  let header-fill = rgb("#fad3db") 
  
  box(
    width: 100%,
    fill: header-fill,
    radius: 5pt,
    stroke: black,
    [
      #pad(
        x: 10pt,
        y: 8pt,
        [
          #text(weight: "regular")[#number #h(2pt) example #h(2pt)] 
          #if term != none {
            text(style: "italic")[#term]
          }
          
          #pad(top: 5pt)[
            #content
          ]
        ]
      )
    ]
  )
}


#let proof(number: none, term: none, content) = {
  let header-fill = rgb("#d7efcb") 
  
  box(
    width: 100%,
    fill: header-fill,
    radius: 5pt,
    stroke: black,
    [
      #pad(
        x: 10pt,
        y: 8pt,
        [
          #text(weight: "regular")[#number #h(2pt) Proof #h(2pt)] 
          #if term != none {
            text(style: "italic")[#term]
          }
          
          #pad(top: 5pt)[
            #content
          ]
        ]
      )
    ]
  )
}




We use a partition $x_0,x_1,...,x_n$ of [a,b] to think of [a,b] as a union of closed subintervals, as follows:

$
[a,b] = [x_0,x_1] union [x_1,x_2] union ... [x_(n-1),x_n] 
$


#definition(
  number: "1.2",
  term: "notation for infimum and supremum of a function",
  [
    If $f$ is a real-valued function and $A$ is a subset of the domain of $f$ , then
    
    $
    inf_A f = inf{f(x) :x in A } 
    
    "and"  

    sup_A f = sup{f(x) :x in A}
    $
  ]
)

for example:

if function is $f(x) = x^2 $, The domain is real numbers,Subset $A = [-2,1]$

$
{f(x) : x in A } = {x^2 : x in [-2,1]} = [0,4]
$

$
inf_A f = 0 "and" sup_A f = 4
$


#definition(
  number: "1.3",
  term: "lower and upper Riemann sums",
  [
    Suppose $f : [a, b] → R $ is a bounded function and $P$ is a partition $x_0, . . . , x_n "of" [a, b]$. The lower Riemann sum $L(f , P, [a, b])$ and the upper Riemann sum
    $U(f , P, [a, b])$ are defined by:

    $
    L(f,P,[a,b]) = sup_A L(f,P,[a,b])

    "and"

    U(f,P,[a,b]) = inf_A U(f,P,[a,b])
    $
    
  ]
)

不难理解,lower Riemann sum 和 upper Riemann sum 就是近似 $f$ 在 [a,b] 的面积,只不过区别就是一个从下限近似,一个从上限近似而已.

#example(
  number: "1.1",
  term: "lower and upper Riemann sums",
  [
    Define $f:[0,1] arrow RR "by" f(x) = x^2$,Let $P_n$ donote the partition  $0,1/n,2/n,...,1 "of" [0,1]$:

    For the partition, we have $x_j - x_(j-1)= 1/n $ for each $j=1,...,n$, Thus:

    $
    L(x^2,P_n,[0,1]) = 1/n sum^n_(j=1) (j-1)^2/n^2 = (2n^2-3n+1)/(6n^2)
    $  
    and

    $
    U(x^2,P_n,[0,1]) = 1/n sum^n_(j=1) (j^2)^2/n^2 = (2n^2+3n+1)/(6n^2)
    $
  ]
)
由此可得,分的足够多,面积足够的接近真实值,下黎曼和增大,上黎曼和减小

#definition(
  number: "1.4",
  term:"lower Riemann sums ≤ upper Riemann sums",
  [
    suppose:$f:[a,b] arrow RR $ is bounded function and P, P' are partitions of [a,b]. then:

    $
    L(f,P,[a,b]) <= U (f,P',[a,b])
    $
  ]

)

We have been working with lower and upper Riemann sums. Now we define the
lower and upper Riemann integrals

#definition(
  number: "1.5",
  term:"lower and upper Riemann integrals",
  [
    suppose:$f:[a,b] arrow RR $ is bounded function. The lower Riemann integral $L(f,[a,b])$ and the upper Riemann integral $U (f,[a,b])$ of $f$ are defined by

    $
    L(f,[a,b]) = sup_p L(f,P,[a,b])
    $
    and
    $
    U(f,[a,b]) = inf_p U(f,P,[a,b])
    $
    where the supremum and infimum above are taken over all partitions P of [a, b]
  ]

)

Same reason:

#definition(
  number: "1.6",
  term:"lower Riemann integral ≤ upper Riemann integral",
  [
    suppose:$f:[a,b] arrow RR $ is bounded function. then:

    $
    L(f,[a,b]) <= U (f,[a,b])
    $
  ]
)

Instead of choosing between the lower Riemann integral and the upper Riemann
integral, the standard procedure in Riemann integration is to consider only functions
for which those two quantities are equal.
#definition(
  number: "1.7",
  term:"Riemann integrable; Riemann integral",
  [
    - A bounded function on a closed bounded interval is called Riemann integrable if its lower Riemann integral equals its upper Riemann integral.

    - If $f:[a,b] arrow RR$ is Riemann integrable, then the Riemann integral $integral_a^b f $ is defaned by 
  
    $
    integral_a^b f = L(f,[a,b]) = U (f,[a,b])
    $  
  ]
)


#example(
  number: "1.2",
  term:"computing a Riemann integral",
  [
   $ "Define" f [0,1] arrow RR "by" f(x) = x^2 $
   then
   
   $
   U(f,[0,1])<=inf_(n in ZZ^+) (2n^2+3n+1)/(6n^2) = 1/3  = sup_(n in ZZ^+) (2n^2-3n+1)/(6n^2) <=L(f,[0,1])
   $
  ]
)

The paragraph above shows that
$U(f , [0, 1]) ≤ 1/3 ≤ L(f , [0, 1])$. this shows that
$L(f , [0, 1]) = U(f , [0, 1]) = 1/3$
. Thus $f$ is Riemann integrable and
$
integral_0^1 f = 1/3
$

Now we come to a key result regarding Riemann integration. Uniform continuity
provides the major tool that makes the proof work.


#definition(
  number: "1.8",
  term:"continuous functions are Riemann integrable",
  [
    Every continuous real-valued function on each closed bounded interval is Riemann integrable.
  ]
)

#proof(
  number: "1.9",
  term:"about continuous functions are Riemann integrable",
  [
    $
    |f(s)-f(t)| < epsilon "for all " s,t in [a,b] "with" |s-t|< delta. 
    $

    Let $n in ZZ^+$ be such that $(b-a)/n < delta$
    
    Let P be the equally spaced partition $a = x_0,x_1,...x_n = b $ of [a,b] with

    $
    x_j -x_(j-1) =(b-a)/n
    $ 
    for each $j=1,...,n$,then:
    
    $
    U(f,[a,b])-L(f,[a,b])&<=U(f,[a,b])-L(f,P,[a,b])\
    & = (b-a)/n sum^n_(j=1) (sup_([x_(j-1),x_j]) f - inf_([x_(j-1),x_j]) f)\
    & = (b-a)epsilon
    $
  
  ]
)

Hence $f$ is Riemann integrable.


#definition(
  number: "1.10",
  term:"bounds on Riemann integral",
  [
    suppose $f : [a,b] arrow RR $ is Riemann integrable. Then:

    $
    (b-a) inf_([a,b]) f <= integral_a^b f<=(b-a) sup_([a,b]) f
    $ 
  ]
)

#proof(
  number: "1.11",
  term:"about bounds on Riemann integral",
  [
  Let P be the trivial partition $a=x_0,x_1=b$
  then:

  $
  (b-a) inf_([a,b]) f = L(f,P,[a,b])<=L(f,[a,b]) = integral _a^b f
  $
  
  ]
)

== Riemann Integral Is Not Good Enough

the Riemann integral has several deficiencies.
In this section, we discuss the following three issues:

- 黎曼积分不能处理有许多不连续的函数；
- 黎曼积分不能处理无界函数；
- 黎曼积分在极限情况下不能很好地工作

#example(
  number: "1.12",
  term:"a function that is not Riemann integrable",
  [ 
    $ "Define" f: [0,1] arrow RR "by"$

    $ f(x) = cases(
      1 "if" x "is rational",
      0 "if" x "is irrational."
    ) $

    $ "If" [a,b] subset [0,1] "with" a < b, "then" $

    $ "inf"_([a,b]) f = 0 "and" "sup"_([a,b]) f = 1 $
  ]
)
