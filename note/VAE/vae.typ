// vae.typ

#import "template.typ": project, chapter

#show: project.with(
  title: "An Introduction to\nVariational Autoencoders",
  author: "ZTS",
  email: "plote5024@gmail.com",
  logo: ""
)

#chapter("Introduction")

== Motivation
#v(1em)
One major division in machine learning is generative versus discriminative modeling. Generative Models: Generative models aim to learn the joint distribution of all variables. Generative models simulate the process of generating data in the real world. For example, meteorologists use complex partial differential equations to model weather, and astronomers use equations of motion to model the formation of galaxies. Scientific modeling is often generative modeling, which reveals the generation process by hypothesising and testing theories. Generative models focus on the generation process of data, and Bayesian methods focus on updating beliefs about parameters given data.
Discriminative Models: Discriminative models aim to learn predictors from observed data, directly learning the mapping relationship from input to output. Discriminative models make classification or regression predictions directly based on input features.

Details that we don't know or care about, the nuisance variables, are called noise.

To turn the generative model into a discriminator, we need to use Bayes' rule. This is because the generative model can provide the joint distribution of categories, and Bayes' rule can convert this information into the conditional probability required in the classification task. The generative model (joint distribution) can be converted to the discriminative model (conditional distribution) through Bayes.

Therefore, if the model is wrong (and it is almost always wrong to some extent!), if one is only interested in learning to discriminate, and if one is in an environment with sufficiently large amounts of data, then a purely discriminative model will usually lead to fewer errors in the discriminative task. However, depending on the amount of surrounding data, it may pay off to study the data generation process as a way to guide the training of a discriminator (e.g., a classifier).

Generative modeling can be useful more generally. One can think of it as an auxiliary task.This quest for disentangled,semantically meaningful, statistically independent and causal factors of variation in data is generally known as unsupervised representation learning, and the variational autoencoder (VAE) has been extensively employed for that purpose

*The VAE can be viewed as two coupled, but independently parameterized models: the encoder or recognition model, and the decoder or
generative model.* 

These two models support each other. The recognition model delivers to the generative model an approximation to its
posterior over latent random variables, which it needs to update its
parameters inside an iteration of “expectation maximization” learning.
Reversely, the generative model is a scaffolding of sorts for the recognition model to learn meaningful representations of the data, including
possibly class-labels. The recognition model is the approximate inverse
of the generative model according to Bayes rule.

VAEs marry graphical models and deep learning. The generative
model is a Bayesian network of the form $p(x|z)p(z)$, or, if there are multiple stochastic latent layers, a hierarchy such as $p(x|z_L)p(z_L|z_L-1)···p(z_1|z_0)$. Similarly, the recognition model is also a conditional Bayesiannetwork of the form $q(z|x)$ or as a hierarchy, such as $q(z_0|z_1)...q(z_L|X)$.But inside each conditional may hide a complex (deep) neural network, $"e.g." space bold(z|x) tilde f(x, epsilon)$, with $f$ a neural network mapping and $epsilon$ a noise
random variable. Its learning algorithm is a mix of classical (amortized,variational) expectation maximization but through the reparameterization trick ends up backpropagating through the many layers of the
deep neural networks embedded inside of it.


== Overview
#v(1em)
The framework of variational autoencoders (VAEs)provides a principled method for jointly learning deep latent-variable models and corresponding inference models using stochastic gradient descent. The framework has a wide array of applications from generative modeling, semi-supervised learning to
representation learning.

== Probabilistic Models and Variational Inference
#v(1em)

Let's use $bold(x)$ as the vector representing the set of all observed variables whose joint distribution we would like to model. Note that for notational simplicity and to avoid clutter, we use lower case bold (e.g. x) to denote the underlying set of observed random variables, i.e. flattened and concatenated such that the set is represented as a single vector. 

We assume the observed variable $bold(x)$ is a random sample from an unknown underlying process, whose true (probability) distribution $p^*(bold(x))$ is unknown. We attempt to approximate this underlying process with a chosen model $p_theta(bold(x))$, with parameters $theta$:

$
bold(x) tilde p_(theta)(bold(x))
$
The learning process is usually to find the value of the parameter θ so that the probability distribution function $p_(theta)(bold(x))$ given by the model approximates the true distribution of the data $p^*(bold(x))$:
$
p_theta (bold(x)) approx p^*(bold(x))
$
we wish $p_(theta)(bold(x))$ to be sufficiently flexible to be able to adapt to the data, such that we have a chance of obtaining a sufficiently accurate model.

=== Conditional Models
#v(1em)
Generally speaking, we are trying to predict the output variable $bold(y)$ from the input variable $bold(x)$. So we want to achieve:
$
p_(theta)(bold(y)|bold(x)) approx p^*(bold(y)|bold(x))
$
A relatively common and simple example of conditional modeling is image classification, where x is an image, and y is the image's class, as labeled by a human, which we wish to predict. In this case, $p_(theta)(bold(y)|bold(x))$ is typically chosen to be a categorical distribution, whose parameters are computed from $bold(x)$.

Conditional models become more difficult to learn when the predicted variables are very high-dimensional, such as images, video or sound. One example is the reverse of the image classification problem:prediction of a distribution over images, conditioned on the class label. Another example with both high-dimensional input, and highdimensional output, is time series prediction, such as text or video prediction.


== Parameterizing Conditional Distributions with Neural Networks
#v(1em)
neural networks parameterize a categorical distribution $p_(theta)(y|x)$ over a class label $bold(y)$, conditioned on an image $bold(x)$.

The neural network accepts an input image $bold(x)$ and outputs a vector $p$, where each element $p_i$ in this vector represents the probability that the input image belongs to category $i$.

$
bold(P) = "NeuralNet"(bold(x))
$
Category distribution

$
p_(theta) = "Categorical"(y;bold(P))
$

== Directed Graphical Models and Neural Networks
#v(1em)
PGMs(Bayesian networks). Directed graphical models are a type of probabilistic models where all the variables are topologically organized into a directed acyclic graph. The joint distribution over the variables of such models factorizes as a product of prior and conditional distributions:
$
p_(theta) (bold(X_1),...,bold(X)_M) = product_(j=1)^M p_(theta)(bold(X)_j | P_a (bold(X)_j))
$
If all variables in the directed graphical model are observed in the data,
then we can compute and differentiate the log-probability of the data
under the model, leading to relatively straightforward optimization.


== Learning in Fully Observed Models with Neural Nets 
#v(.8em)
Using calculus' chain rule and automatic differentiation tools, we can efficiently compute gradients of this objective, i.e. the first derivatives of the objective $w.r.t.$ its parameters $theta$. 

$ 
1/N_D log p_theta(D) approx 1/N_M log p_theta(M) = 1/N_M sum_{x in M} log p_theta(x) 
$
// 无偏估计量
$
 1/N_D nabla_theta log p_theta(D) approx 1/N_M nabla_theta log p_theta(M) = 1/N_M sum_{x in M} nabla_theta log p_theta(x) 
$

== Learning and Inference in Deep Latent Variable Models
#v(.8em)
We can extend fully-observed directed models, discussed in the previous section, into directed models with latent variables. Latent variables are
variables that are part of the model, but which we don't observe, and are therefore not part of the dataset. We typically use z to denote such
latent variables. 

In case of unconditional modeling of observed variable $bold(x)$, the directed graphical model would then represent a joint distribution
$p_θ(x, z)$ over both the observed variables $x$ and the latent variables $z$.The marginal distribution over the observed variables $p_θ(x)$, is given by:

$
p_(theta) = integral p_(theta) (x,z) dif z
$

== Deep Latent Variable Models
#v(.8em)
We use the term deep latent variable model (DLVM) to denote a latent
variable model $p_θ(x, z)$ whose distributions are parameterized by neural networks. Such a model can be conditioned on some context, like
$p_θ(x, z|y)$. One important advantage of DLVMs, is that even when each
factor (prior or conditional distribution) in the directed model is relatively simple (such as conditional Gaussian)

#set list(marker:text(orange)[#sym.notes.up])

composition:

- Latent Variables:These are the unobservable implicit variables in the model.
- Observed Variables:Observed data are generated by latent variables through a generative process.
- Generative Model:The generative model defines how to generate observations from latent variables. A deep neural network is usually used to represent the generative process.
$
p(x|z) = f(z;theta)
$

- Inference Model:Inference models are used to infer latent variables from observed data, usually through a deep neural network.

$
q(z | x) = g(x;phi)
$


#chapter("Variational Autoencoders")

= Evidence Lower Bound (ELBO)
$ 
log p_theta(x) &= EE_(q_phi(z|x)) [log p_theta(x)]\
            &= EE_(q_phi(z|x)) [log [p_theta(x,z) / p_theta(z|x)]]\
            &= EE_(q_phi(z|x)) [log [p_theta(x,z) q_phi(z|x) / (q_phi(z|x) p_theta(z|x))]]\
            &= underbrace(
              EE_(q_phi(z|x)) [log [p_theta(x,z) / q_phi(z|x)]],
               = L_theta phi(x)\
               "ELBO"
             )
            underbrace(
               + EE_(q_phi(z|x)) [log [q_phi(z|x) / p_theta(z|x)]],
               = D_"KL" (q_phi(z|x) || p_theta(z|x))
             )
$

= EM
Expectation Step:
$
q(Z|theta^(t)) = p(Z | X,theta^(t))
$

Maximization Step:
$
theta^(t+1) = arg max_(theta) EE_q(Z|theta^((t)))[log p (X,Z|theta)]
$
The EM algorithm ensures that after each iteration, the likelihood function increases or remains unchanged until it converges to a local optimal solution or a stable point.

How to understand:
$
p(X|theta) = p(X,Z|theta)/p(Z|X,theta)
$

$
log P(X|theta) &= log P(X,Z | theta) -log P(Z|X,theta)\
           &= log P(X,Z |theta)/q(Z) - log P(Z|X,theta)/q(Z)\ 

$

$
"left" &= integral_z q(Z) log P(X|theta) dif z
&= log P(X| theta) integral_z q(z) dif z
&= log P(X|theta)
$
#v(.9em)      
$
"right" &= integral_Z q(Z) log p(X,Z|theta)/q(Z) dif Z  - integral_z q(Z) log p(Z|X,theta)/q(Z) dif Z
$
#v(3em)
$log P(X|theta) = "ELBO" + "KL"(q||p)$.
#v(1em)
So at this point we can get the meaning of : $theta$
$
theta &= arg max_theta "ELBO"\
  &= arg max _theta integral  q(z) log p(x,z|theta)/q(z) dif z

$
#v(.9em)

     
      
