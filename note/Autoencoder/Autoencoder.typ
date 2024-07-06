#import "template.typ":*
//公式大小设置
#set page(margin: 1.75in)
#set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
#show par: set block(spacing: 0.55em)
#show heading: set block(above: 1.4em, below: 1em)

#let font = (
  main: "IBM Plex Serif",
  mono: "IBM Plex Mono",
  cjk: "Noto Serif CJK SC",
)

#set page(
  paper : "a4", 
  margin: (x:1.8cm,y:1.5cm),
)

#align(center,text(17pt)[
  *AUTOENCODER*
])

#v(0.8em)

#grid(
  columns: (8fr),
  align(center)[
    ZTS \
    #link("plote5024@gmail.com")
  ]
)

#v(0.8em)

#align(center)[
  #set par(justify: true)
  *Abstract*\  
]

#v(0.8em)

An autoencoder is an artificial neural network used for data encoding in unsupervised learning. Its purpose is to learn a compressed representation of data. A typical autoencoder consists of two parts: an encoder and a decoder.

I will learn what they are, what their limitations are, typical use cases, and look at some examples. I will start with a general introduction to autoencoders and discuss the role of activation functions and loss functions in the output layer. I will then discuss what reconstruction error is. Finally, I will look at typical applications such as dimensionality reduction, classification, denoising, and anomaly detection.

#let subfigure(body, caption: "", numbering: "(a)") = { 
  let figurecount = counter(figure) 
  let subfigurecount = counter("subfigure") 
  let subfigurecounterdisply = counter("subfigurecounter") 
  let number = locate(loc => { 
    let fc = figurecount.at(loc) 
    let sc = subfigurecount.at(loc) 
    if fc == sc.slice(0,-1) {      
      subfigurecount.update(        
        fc + (sc.last()+1,)
        )
        subfigurecounterdisply.update((sc.last()+1,)) 
      } 
      else {      
        subfigurecount.update( fc + (1,))      
        subfigurecounterdisply.update((1,))    
      }    
      subfigurecounterdisply.display(numbering)  
  })
}

#v(1em)

#align(center,text(15pt)[* I.Introduction*])

#v(1em)

There are three main components of an autoencoder: encoder, latent feature representation, and decoder. Encoders and decoders are just simple functions, while the name latent feature representation usually refers to a tensor of real numbers. In general, we want an autoencoder to reconstruct the input well.

For example, the latent features of the handwritten digit 4 might be the number of lines required to write each digit or the angle of each line and how they are connected. Learning how to write a digit certainly does not require learning the grayscale value of each pixel in the input image. We humans certainly do not learn to write by filling pixels with grayscale values. In the process of learning, we extract basic information that can help us solve a problem (e.g., write a digit). This latent representation (how to write each digit) is very useful for various tasks (e.g., feature extraction that can be used for classification or clustering) or simply understanding the basic characteristics of a dataset.

#v(.8em)

#figure(
  image("/img/autoencoder.png", width:70%),
  caption: [
     General structure of an _autoencoder_.
  ],
) 

#v(1.8em)
#align(center,text(15pt)[*II.Structure and Function*])
#v(1em)
The autoencoder has two parts, including the encoder and the decoder. The latent feature is the intermediate representation between the encoder and the decoder. Strictly speaking, it is part of the encoder output, not an independent structural part. In layman's terms, the encoder is responsible for "reducing the burden", reducing the data dimension, and recording all the data with fewer parameters. The decoder is responsible for restoring the data using the provided low-dimensional data. We call the input data c and the restored data b. How do we judge the result of our restoration? We only need to use the loss function to compare the input result with the output result.
== For the encoder $bold(g)$:
$
bold(h_i) = g(X_i)
$
Single-layer encoder:
$
bold(h) = g(X) = f(W_e X+b_e)
$
The input data is $X_i in RR^n$, $bold(h_i) in RR^q$ is the potential feature representation (low-dimensional representation), ($q < n$)and the g function is the encoder function, *which cleverly represents the dynamic representation of mapping the input data to the latent space (high-dimensional to low-dimensional)*

== For the decoder $bold(f)$:
$
tilde(X_i) = f(h_i) = f(g(X_i)) 
$
Single layer decoder:
$
tilde(X) = f(h) = g(W_d h +b_d)
$
Same as encoder,
$h_i in  RR^q$ refers to the latent feature representation. $tilde(x_i)$ is the reconstructed data. $f$ is the decoder function that maps the latent features back to the original data space.
$RR^n$ represents the high-dimensional space where the input data $x_i$ and the reconstructed data $tilde(x_i)$ are located. And $RR^q$ represents the low-dimensional space where the latent feature representation $h_i$ is located, so we can also get $q<n$, which is exactly the opposite of the encoder process.

== Loss Function

$
L(bold(X), tilde(bold(X))) 
&= norm(bold(X) - tilde(bold(X)))^2 \
&=(bold(X_i)-bold(tilde(X_i)))^T (bold(X_i)-bold(tilde(X_i)))
$

== Optimization goals during autoencoder training

$
"arg" min_(f,g) angle.l Delta(bold(X_i),tilde(bold(X_i))) angle.r 
&= "arg" min_(f,g) angle.l Delta(bold(X)_i, f(g(bold(X)_i))) angle.r\
&= "arg" min_(f,g) angle.l norm(bold(X_i)- tilde(bold(X_i)))^2 angle.r\
&= "arg" min_(f,g) 1/N  sum_(i=1)^N L(bold(X_i),bold(tilde(X_i)))\
&="arg" min_(f,g) 1/N sum_(i=1)^N norm(bold(X_i)-f(g(bold(X_i))))^2
$

where $∆$ indicates a measure of how the input and the output of the autoencoder differ (basically our loss function will penalize the difference between input and output) and $< · >$ indicates the average over all observations. Depending on how one designs the autoencoder, it may be possibleto find f and g so that the autoencoder learns to reconstruct the output
perfectly, thus learning the identity function. This is not very useful, as we
discussed at the beginning of the article, and to avoid this possibility, two
main strategies can be used: creating a bottleneck and add regularization in
some form.Adding a "bottleneck,"  is achieved by making the latent
feature's dimensionality lower (often much lower) than the input's. That is
the case that we will look in detail in this article. But before looking at this
case, let's briefly discuss regularization.

#v(1em)
#align(center,text(15pt)[*Regularization in autoencoders*])
#v(1em)
The purpose of regularization is to prevent the model from overfitting on the training data by limiting the size of model parameters, thereby improving the model's generalization ability on new data.Intuitively it means enforcing sparsity in the latent feature
output. The simplest way of achieving this is to add a $l_1$ or $l_2$ regularization
term to the loss function. That will look like this for the $l_2$ regularization term:

$ "arg" min_(f,g) (
  bb(E)[Delta(bold(x)_i), g(f(bold(x)_i))] + lambda sum_i theta_i^2
)
$

$theta_i$ is the set of all weight and bias parameters in the autoencoder. These parameters include:

#set list(marker: text(red)[#sym.notes.up])
- Every element in the encoder's weight matrix and bias vector.
- Every element in the decoder's weight matrix and bias vector.



#let body-text = 10pt
#let summary-text = 11pt

For the single-layer encoder and single-layer decoder above, we assume the following parameters and can get the parameters of $theta_i$
#grid(
  columns: (5fr, 5fr),
  gutter: 16pt,

  column-gutter: 0fr,
  [
    #text(size: body-text)[
      #set list(marker: text(green)[#sym.bullet])
      Assume the following parameters
      - encoder weight matrix: $bold(W)_e$
      - encoder bias vector: $bold(b)_e$
      - decoder weight matrix: $bold(W)_d$
      - decoder bias vector: $bold(b)_d$
    ]
  ],

  [
    #text(size: body-text)[
      #set list(marker: text(blue)[→])
      $theta_i$ includes
      - Each element in the encoder weight matrix $w_e_(i j)$
      - Each element in the encoder bias vector $b_e_i$
      - Each element in the decoder weight matrix $w_b_(i j)$
      - Each element in the decoder bias vector $b_d_i$
    ]
  ]
)
The specific form of the regularization term is as follows:
$
lambda sum_i theta_i^2 = lambda(sum_(i,j)w_e_(i j)^2+sum_(i)b_e_i^2+sum_(i,j)w_d_(i j) +sum_i b_d_i ^2)
$
