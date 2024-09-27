#import "@preview/ilm:1.2.1": *

#show: ilm.with(
  title: [Diffusion Models],
  author: "Plote",
  date: datetime(year: 2024, month: 09, day: 25),
  abstract: [Diffusion Models is a probabilistic generative model based on gradually corrupting data into noise and generating data from noise by learning the inverse denoising process. It is widely used for high-quality sample generation and is trained by optimizing the variational lower bound.],
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true)
)


= INTRODUCTION

扩散模型已经成为最先进的深度生成模型家族。它们打破了生成对抗网络(GANs)在具有挑战性的图像合成任务中的长期统治地位，并且在各种领域也显示出潜力，包括计算机视觉，自然语言处理，时间数据建模，多模态建模，鲁棒机器学习，到计算化学和医学图像重建等领域的跨学科应用。

= FOUNDATIONS OF DIFFUSION MODELS

*Diffusion models are a family of probabilistic generative models that progressively destruct data by injecting noise,
then learn to reverse this process for sample generation. *

目前对扩散模型的研究主要基于三种主要的公式:

- *denoising diffusion probabilistic models (DDPMs) *

- *score-based generative models (SGMs) *

- *stochastic differential equations(Score SDEs)*

我们将对这三个公式进行独立的介绍，同时讨论它们之间的联系。