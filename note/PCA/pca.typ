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

#v(1em)
#show: rest => columns(2, rest)
#align(center,text(15pt)[*I. INTRODUCTION
*])
#v(1em)
Principal component analysis (PCA) is a standard tool in modern data analysis - in fields as diverse as neuroscience to computer graphics - because it is a simple, nonparametric method for extracting relevant information from messy data sets.
I record my intuition for learning PCA. I will refer to the author's article (link is in the appendix) to start with a simple example and provide an intuitive explanation of the PCA goal. Combined with my own knowledge, using mathematical rigor, the framework of linear algebra, I gradually understand the clear solution. At the same time, I clearly understand why and how PCA is closely related to the mathematical technique of singular value decomposition (SVD). The formulas in the notes combine my own derivation in the learning process with the understanding of the author's article and notes, and record what I think is a more rigorous and correct formula.
Finally, I introduce a sentence from the author: Although the proofs are not so important for this tutorial, they are provided for adventurous readers who want a more comprehensive understanding of the mathematics.
#v(1em)
#align(center,text(15pt)[* II. Basic idea
*])
#v(1em)
The goal of principal component analysis is to identify the
most meaningful basis to re-express a data set. The hope is
that this new basis will filter out the noise and reveal hidden
structure. 

now state more precisely what PCA
asks: *Is there another basis, which is a linear combination of the original basis, that best re-expresses our data set?*


A close reader might have noticed the conspicuous addition of
the word linear. Indeed, PCA makes one stringent but powerful assumption: linearity. Linearity vastly simplifies the problem by restricting the set of potential bases. With this assumption PCA is now limited to re-expressing the data as a linear
combination of its basis vectors.
Let X be the original data set, where each column is a single
sample (or moment in time) of our data set (i.e. ~X). 
Let Y be another m × n matrix related by a linear transformation P. X is the original recorded data set and Y is a new
representation of that data set.

$
bold(P) bold(X) = bold(Y)
$

#let script-x = math.italic("X")

Also let us define the following quantities.

- $bold(p_i)$ are the rows of $bold(P)$
- $bold(x_i)$ are the columns of $bold(X)$ (or individual $arrow(x)$).
- $bold(y_i)$ are the columns of $bold(Y)$.

*I think the basic understanding is also here.*
#set list(marker: text(blue)[→])
- *$bold(P)$ is a matrix that transforms $bold(X)$ into $bold(Y)$.*
- *Geometrically, $bold(P)$ is a rotation and a stretch which again transforms $bold(X)$ into $bold(Y)$*

I assume a transformation matrix S here. You can see that its function is to lengthen the x-axis of the original coordinate system by a times and the y-axis by b times.Here S plays the role of R.
$
S = mat(a,0;0,b;delim: "[")
$

Similarly, I now want to perform a rotation transformation,The multiplication of the r matrix means that the original basis vector i changes from $mat(1;0)$ to $mat(cos (Theta);sin (Theta))$, and j changes from $mat(0;1)$ to $mat(-sin (Theta);cos (Theta))$, which naturally corresponds to a rotation transformation in the coordinate system.
$
R = mat(cos (Theta),-sin (Theta);sin (Theta),cos (Theta);delim:"[")
$
The matrix naturally realizes the characteristics of translation, expansion, rotation, etc., so for PCA, finding a good result often requires multiple matrices to be superimposed on each other.

#v(1em)

#align(center,text(15pt)[* III.VARIANCE AND THE GOAL
*])
#v(1em)

= What is Covariance
The covariance measures the degree of the linear relationship
between two variables. A large positive value indicates positively correlated data. Likewise, a large negative value denotes negatively correlated data. The absolute magnitude of
the covariance measures the degree of redundancy. Some additional facts about the covariance.
= Covariance Matrix
#v(0.5em)
=== Population Covariance
$
"Cov"(x, y)= sum^n_(i=1)((x_i-overline(x))(y_i-overline(y)))/n
$
The denominator here is $n$, which means that we have all the sample data, that is, we are studying the overall data situation
=== Sample Covariance

$
"Cov"(x, y)= sum^n_(i=1)((x_i-overline(x))(y_i-overline(y)))/(n-1)
$
The denominator here is $n-1$, which is called the *Bessel correction*. This is because when we use only a sample (rather than the entire population) to estimate the covariance, we need to correct the estimate. The specific reason is as follows:
#set list(marker: text(green)[✓])
- *Unbiased estimate:* If we use the sample mean $overline(x)$ and $overline(y)$ instead of the population mean, then directly using the formula with a denominator of $n$ will lead to a biased estimate of the covariance, that is, *the mean is lower than the actual value.* In order to obtain an unbiased estimate, we use $n-1$ to correct this bias.
- *Degrees of freedom:* The sample means $overline(x)$ and $overline(y)$ are calculated based on n samples, and *they themselves also occupy one degree of freedom.* Therefore, when calculating the sample covariance, the actual degree of freedom is $n-1$ instead of n.

Covariance cleverly expresses the relationship between variables with simple numbers, making it easier to see.It's actually the sign of the covariance that matters:


#set list(marker:text(orange)[#sym.floral.r])
- If positive then: the two variables increase or decrease together (correlated)
- If negative then: one increases when the other decreases (Inversely correlated)

$
C = mat("cov"(x,x),"cov"(x,y);"cov"(x,y),"cov"(y,y);delim:"[")
$

also because:
$
"cov"(x,y)=sum^n_(i=1)(x_i y_i)/(n-1)
$

$
"cov"(x,x)=sum^n_(i=1)x_1^2/(n-1)
$

Substitute:

$
C=mat(
  sum^n_(i=1)x_1^2/(n-1),sum^n_(i=1)(x_i y_i)/(n-1);sum^n_(i=1)(x_i y_i)/(n-1),sum^n_(i=1)y_1^2/(n-1);
  delim:"["
)
$

Expand to get:

$

  C_X &= 1/(n-1) mat(x_1,x_2,x_3,x_4;y_1,y_2,y_3,y_4;delim:"[") mat(x_1,y_1;x_2,y_2;x_3,y_3;x_4,y_4;delim:"[") \
    &= 1/(n-1) D D^T
$
$D D^T$ is an $m times m$ matrix, and each element $(i,j)$ of this matrix represents the inner product between feature $i$ and feature $j$. Specifically, the $(i,j)$ element of $D D^T$ represents the sum of the dot products between the $i$th feature and the $j$th feature, which is actually the covariance of the two feature vectors (without centering).\
$n-1$is used to find the average value.\
*In principal component analysis (PCA), this covariance matrix is ​​used to find the principal components of the data, thereby reducing the dimensionality of the data and removing redundant information.*\
We begin by rewriting $C_Y$ in terms of the unknown variable.
$
C_Y &= 1/(n-1) Y Y^T \
   &= 1/(n-1) (P X)(P X)^T \
   &= 1/(n-1) P X X^T P^T \
   &= P(1/(n-1) X X^T)P^T
$
$
C_Y = P C_X P^T 
$
Note that we have identified the covariance matrix of X in the
last line.\
#v(0.2em)
Now comes the trick. We select the matrix $P$ to be a matrix
where each row $pi$
is an eigenvector of $1/n X X^T$.
#v(0.2em)
By this selection,$bold(P ≡ E^T)$. With this relation and Theorem 1 of Appendix
$A (P^(-1) = P^T)$ we can finish evaluating $C_Y$
$
C_Y &= P C_X P^T\
   &= P(E^T D E)P^T\
   &= P(P^T D P)P^T\
   &= (P P^T)D(P P^T)\
   &=(P P^(-1))D(P P^(-1))
$
It is evident that the choice of $P$ diagonalizes $C_Y$. This was
the goal for PCA. We can summarize the results of PCA in the
matrices $P$ and $C_Y$.

#set list(marker: text(red)[#sym.notes.up])
- The principal components of $X$ are the eigenvectors of $C_X =1/n X X^T$
  
- The $i^(t h)$ diagonal value of $C_Y$ is the variance of $X$ along $pi$.

In practice computing PCA of a data set X entails
#set list(marker: text(purple)[#sym.gt.triple]) 
- subtracting off the mean of each measurement type  
- computing the eigenvectors of $C_X$. 