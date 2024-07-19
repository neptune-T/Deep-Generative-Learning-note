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


== Variational Autoencoders



#chapter("Architecture")



== Encoder


== Decoder


