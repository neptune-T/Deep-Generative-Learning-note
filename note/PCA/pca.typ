#import "template.typ":*
//公式大小设置
#set page(margin: 1.75in)
#set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
#show par: set block(spacing: 0.55em)
#show heading: set block(above: 1.4em, below: 1em)

#align(center,text(17pt)[
  *Principal Component Analysis*
])
#grid(
  columns: (8fr),
  align(center)[
    ZTS \
    #link("plote5024@gmail.com")
  ]
)
#align(center)[
  #set par(justify: true)
  *Abstract*\  
]

Principal component analysis (PCA) is a mainstay of modern data analysis.but (sometimes) poorly understood. This manuscript crystallizes this knowledge by deriving from simple intuitions, the mathematics behind PCA. readers of all levels will be able to gain a better understanding of PCA as well as the when, the how and the why of applying this technique.


#show: rest => columns(2, rest)
#align(center,text(10pt)[*I. INTRODUCTION
*])

Principal component analysis (PCA) is a standard tool in modern data analysis - in fields as diverse as neuroscience to computer graphics - because it is a simple, nonparametric method for extracting relevant information from messy data sets.
I record my intuition for learning PCA. I will refer to the author's article (link is in the appendix) to start with a simple example and provide an intuitive explanation of the PCA goal. Combined with my own knowledge, using mathematical rigor, the framework of linear algebra, I gradually understand the clear solution. At the same time, I clearly understand why and how PCA is closely related to the mathematical technique of singular value decomposition (SVD). The formulas in the notes combine my own derivation in the learning process with the understanding of the author's article and notes, and record what I think is a more rigorous and correct formula.
Finally, I introduce a sentence from the author: Although the proofs are not so important for this tutorial, they are provided for adventurous readers who want a more comprehensive understanding of the mathematics.

#align(center,text(10pt)[* II. MOTIVATION: A TOY EXAMPLE
*])

$
S = mat(a,0;0,b;delim: "[")
$

$
R = mat(cos (Theta),-sin (Theta);sin (Theta),cos (Theta);delim:"[")
$


Covariance Matrix

$
"Cov"(x, y)= sum^n_(i=1)((x_i-overline(x))(y_i-overline(y)))/n-1
$



Covariance Matrix

$
C = mat("cov"(x,x),"cov"(x,y);"cov"(x,y),"cov"(y,y);delim:"[")
$

又因为:
$
"cov"(x,y)=sum^n_(i=1)(x_i y_i)/(n-1)
$

$
"cov"(x,x)=sum^n_(i=1)x_1^2/(n-1)
$

代入:

$
C=mat(
  sum^n_(i=1)x_1^2/(n-1),sum^n_(i=1)(x_i y_i)/(n-1);sum^n_(i=1)(x_i y_i)/(n-1),sum^n_(i=1)y_1^2/(n-1);
  delim:"["
)
$

展开可得：
$
C = 1/(n-1)mat(x_1,x_2,x_3,x_4;y_1,y_2,y_3,y_4;delim:"[")mat(x_1,y_1;x_2,y_2;x_3,y_3;x_4,y_4;delim:"[")=1/(n-1)D D^T
$


