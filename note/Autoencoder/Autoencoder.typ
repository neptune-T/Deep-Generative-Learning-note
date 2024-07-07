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
#align(center,text(15pt)[*III.Regularization in autoencoders*])
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

$ lambda sum_i theta_i^2 = lambda (
  sum_(i,j) w_(e_(i j))^2 + 
  sum_i b_(e_i)^2 + 
  sum_(i,j) w_(d_(i j))^2 + 
  sum_i b_(d_i)^2
) $

#v(1em)
#align(center,text(15pt)[*IV.Feed Forward Autoencoders*])
#v(1em)
The difference between ffa and the original autoencoder:
#set list(marker:text(purple)[#sym.gt.tri])

- Symmetry: The structures of encoder and decoder are usually symmetrical. This means that the encoder gradually reduces the number of neurons from the input layer to the latent feature layer, while the decoder gradually increases the number of neurons from the latent feature layer to the output layer, making the entire network structure symmetrical at the middle layer (bottleneck layer).
- Decrease the number of neurons as you move towards the center of the network: In the encoder part, the number of neurons in each layer gradually decreases until it reaches the middle layer (bottleneck layer). This is designed to compress the data so that it can be represented in a low-dimensional space.
- Bottleneck layer: The middle layer (bottleneck layer) has the least number of neurons. The output of this layer is a low-dimensional representation or feature representation of the input data. The bottleneck layer is designed to force the network to learn the most important features of the data.
- Bottleneck effect: By reducing the number of neurons in the middle layer, the network is forced to compress information, remove redundant data, and learn the core features of the data. This structure helps improve the generalization ability of the model and reduce overfitting.
#figure(
  image("/img/ffa.png", width:70%),
  caption: [
     Internal structure of FFA.
  ],
) 
= Activation Function of the Output Layer
In neural network based autoencoders, the activation function of the output layer plays a particularly important role. The most commonly used functions are ReLU and sigmoid. Let's look at both of these functions and see some tips on when to use which function and when to use which.

#let body-text = 10pt
#let summary-text = 11pt
#grid(
  columns: (5fr, 5fr),
  gutter: 19pt,
  column-gutter: .7fr,
  [
    #text(size: body-text)[
      = ReLU
      The *ReLU* activation function can assume all values in the range $[0,#sym.infinity]$. As a remainder, its formula is
      $
      "ReLU"(x) =max (0,x)
      $
      This choice is good when the input observations $x_i$ assume a wide range
      of positive values. If the input $x_i$ can assume negative values, the ReLU
      is, of course, a terrible choice, and the identity function is a much better choice.
      $
      f(x) = cases(0","x<=0,
      x","x>0)
      $
      #figure(image("/img/relu.png",width:90%),
      caption: [relu image.
      ],) 
      #set list(marker:text(blue)[#sym.checkmark.light])
      - ReLU is non-linear, which means *it can capture complex patterns in the input data.*
      - *Avoid gradient vanishing*: The derivative of ReLU in the positive interval is a constant 1, and the derivative in the negative interval is 0, *so it can effectively alleviate the gradient vanishing problem when training deep neural networks. *This makes training faster and the model deeper
      - Sparse activation: ReLU outputs zero for negative values, *which means it produces sparse activations (many neurons have zero outputs)*, which helps reduce computation and improves the generalization of the model
      
      *ReLU is often used as the activation function for hidden layers because it can effectively train deep neural networks and capture complex nonlinear relationships.*
    ]
  ],
  [
    #text(size: body-text)[
      = sigmoid
      The *sigmoid* function $#sym.sigma$ can assume all values in the range $[0,1]$. As a remained its formula is:
      $
      sigma(x)= 1/(1+e^(-x))
      $
      #figure(image("/img/sigmoid.png", width:90%),
      caption: [sigmoid image.
      ],) 
      This activation function can only be used if the input observations xi are all in the range $[0,1]$ or if you have normalized them to be in that range.Consider as an example the MNIST dataset. Each value of the input observation $x_i$ (one image) is the gray values of the pixels that can assume any value from 0 to 255. Normalizing the data by dividing the pixel values by 255 would make each observation (each image) have only pixel values between 0 and 1. In this case, the sigmoid would be a good choice for the output layer's activation function.
      #set list(marker:text(purple)[#sym.checkmark.light])
      - Probability output: Sigmoid maps the input value to the (0, 1) interval, which is suitable as a probability output, especially for *binary classification problems*.
      - Smooth nonlinearity: Sigmoid is a smooth nonlinear function that can map any real number to a finite range.
      - Application: Sigmoid is often used as the activation function of the output layer, especially in binary classification problems, because it can provide a probability value indicating the possibility that a sample belongs to a certain category.
    ]
  ]
)
= Loss Function
The loss function compares the difference between a and b and tries to reduce the value. The previous loss function is:
$
EE[Delta(bold(X_i) tilde(bold(X_i)))]
$
For FFA, g; and f will be the functions obtained through the dense layers, as described in the previous sections. Remember that the autoencoder is trying to learn an approximation of the identity function; therefore, you need to find the weights in the network that give the minimum difference according to some metric $(∆(·))$ between $x_i$ and $tilde(x_i)$. Two loss functions are widely used for autoencoders: mean squared error (MSE) and binary cross entropy (BCE).

= Mean Square Error
Since an autoencoder is trying to solve a regression problem, the most common choice as a loss function is the Mean Square Error (MSE):
$
L_"MSE"= "MSE" = 1/M sum_(i=1)^M norm(bold(X_i)-tilde(bold(X_i)))^2
$
L2 norm:
$
norm(bold(X_i)-tilde(bold(X_i))) = sqrt(sum_(j=1)^N (x_(i j)-tilde(x)_(i j)))
$
Then square it, expressed as:
$
norm(bold(X_i)-tilde(bold(X_i)))^2 = sum_(j=1)^N (x_(i j )-tilde(x)_(i j))
$
The entire formula represents the mean square error of all data samples:
$
L_"MSE"= "MSE"= 1/M sum_(i=1)^M sum_(j=1)^N (x_(i j)-tilde(x)_(i j))^2
$
The symbol $| |$ indicates the norm of a vector,equivalent to the original equation.and M is the number of the observation in the training dataset.


$ (diff L_"MSE")/(diff tilde(x)_j) = (diff)/(diff tilde(x)_j) (1/M sum_(i=1)^M (x_i - tilde(x)_i)^2) $

Since MSE is the average of all sample errors, for each specific
$x$, only the error term corresponding to it is considered:
$
(diff L_"MSE")/(diff tilde(x_j))=-2/M (x_j-tilde(x_j))=0
$
Solving this equation yields:
$
x_j=tilde(x_j)
$
To confirm that this point is a minimum, calculate the second derivative:
$
(diff^2 L_"MSE")/(diff tilde(x_j)^2) = diff/(diff tilde(x_j)) (-2/M (x_j-tilde(x_j)))=2/M
$
Since the second-order derivative is positive, this means that $x_j = tilde(x_j)$,there is a local minimum.


= Binary Cross-Entropy
If the activation function of the output layer of the FFA is a sigmoid function,
thus limiting neuron outputs to be between 0 and 1, and the input features are
normalized to be between 0 and 1 we can use as loss function the binary crossentropy, indicated here with LCE. Note that this loss function is typically
used in classification problems, but it works beautifully for autoencoders.
The formula for it is:
$
L_"CE" = -1/M sum_(i=1)^M sum_(j=1)^n [x_(j,i)log tilde(x)_(j,i)+(1-x_(j,i)log(1-tilde(x)_(j,i)) ]
$

