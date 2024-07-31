#import "@preview/grape-suite:1.0.0": seminar-paper, german-dates

#set text(lang: "de")

#show: seminar-paper.project.with(
    title: "An Introduction to Variational Autoencoders",
    subtitle: "Notes to get started",

    university: [University of Chinese Academy of Sciences],

    semester: german-dates.semester(datetime.today()),

    author: "ZTS",
    email: "plote5024@mail.com",
    address: [
        Beijing
    ]
)

= Introduction

== Motivation
#v(.5em)
机器学习的一个主要分支是生成模型和判别模型。在判别建模中，目标是学习给定观察值的预测器，而在生成建模中，目标是解决学习所有变量*All variables*的联合分布。

生成模型模拟数据在现实世界中的生成方式。在几乎每一门科学中，“建模”都被理解为通过假设理论和通过观察测试这些理论来揭示这个生成过程。例如，当气象学家为天气建模时，他们使用高度复杂的偏微分方程来表达天气的潜在物理特性。生物学家、化学家、经济学家等等也是如此。科学中的建模实际上几乎全是生成模型。

试图理解数据生成过程的另一个原因是，它自然地表达了世界的因果关系。因果关系的优点，就是它们比单纯的相关性更能概括新情况。

为了将生成模型转化为Discriminator，我们需要使用贝叶斯规则。即我们可以将生成模型的输出转换为分类任务中需要的条件概率，从而实现判别功能。

在判别方法中，我们直接学习一个与未来预测方向一致的映射。这与生成模型的方向相反。例如，可以认为一张图像在现实世界中是通过先识别物体，然后生成三维物体，再将其投影到像素网格上来生成的。

而判别模型则直接将这些像素值作为输入，并将其映射到标签上。虽然生成模型能够有效地从数据中学习，但它们往往比纯粹的判别模型对数据做出更强的假设，这通常会在模型出错时导致更高的渐近偏差（*Asymptotic bias*）。

因此，如果模型出错（事实上几乎总是有一定程度的误差），如果我们只关注于学习如何区分，并且我们有足够多的数据，那么纯粹的判别模型在判别任务中通常会导致更少的错误。然而，取决于数据量的多少，研究数据生成过程可能有助于指导判别器（如分类器）的训练。例如，在半监督学习的情况下，我们可能只有少量的标记样本，但有更多的未标记样本。在这种情况下，可以利用数据的生成模型来改进分类。

这种方法可以帮助我们构建有用的世界抽象，这些抽象可以用于多个后续的预测任务。这种追求数据中解缠、语义上有意义、统计上独立和因果关系的变化因素的过程，通常被称为无监督表示学习，而变分自编码器（VAE）已经广泛应用于此目的。

或者，可以将其视为一种隐式正则化形式：通过强制表示对数据生成过程有意义，我们将从输入到表示的映射过程约束在某种特定的模式中。通过预测世界这一辅助任务，我们可以在抽象层面上更好地理解世界，从而更好地进行后续的预测。

变分自编码器（VAE）可以看作是两个耦合但独立参数化的模型：编码器或识别模型*(Encoder or Recognition Model)*，以及解码器或生成模型*(Decoder or Generative Model)*。这两个模型相互支持。识别模型向生成模型提供其后验分布的近似值，后者需要这些近似值在“期望最大化”学习的迭代过程中更新其参数。反过来，生成模型为识别模型提供了一个框架，使其能够学习数据的有意义表示，包括可能的类别标签。根据贝叶斯规则，识别模型是生成模型的近似逆。

与普通的变分推断（VI）相比，VAE框架的一个优势在于识别模型（也称为推断模型）现在是输入变量的一个（随机）函数。这与VI不同，后者对每个数据实例都有一个独立的变分分布，这对于大数据集来说效率低下。识别模型使用一组参数来建模输入与潜变量之间的关系，因此被称为“摊销推断”。这种识别模型可以是任意复杂的，但由于其构造方式，只需一次从输入到潜变量的前馈传递即可完成，因此仍然相对快速。然而，我们付出的代价是，这种采样会在学习所需的梯度中引入采样噪声。

或许VAE框架最大的贡献是认识到我们可以使用现在被称为“重参数化技巧”的简单方法来重新组织我们的梯度计算，从而减少梯度中的方差。

== Aim
#v(.5em)
*provides a principled method for jointly learning _deep latent-variable models_ and corresponding inference models using _stochastic gradient descent_.*

该框架在生成建模、半监督学习和表示学习等方面有广泛的应用。

== Probabilistic Models and Variational Inference
#v(.5em)
由于概率模型包含未知数且数据很少能完整地描述这些未知参数，我们通常需要对模型的某些方面假设一定程度的不确定性。这种不确定性的程度和性质通过（条件）概率分布来描述。在某种意义上，最完整的概率模型形式通过这些变量的联合概率分布来指定模型中所有变量之间的相关性和高阶依赖关系。

我们用 $bold(x)$ 表示所有观测变量的向量，其联合分布是我们希望建模的。（使用小写粗体来表示底层的观测随机变量集，即将其展平和拼接，使该集合表示为一个单一的向量。）

假设观测变量 $bold(x)$ 是来自未知底层过程的随机样本，其真实的概率分布 $p^*(bold(x)) $ 是未知的。我们尝试用一个选定的模型 $p_theta bold(x)$ 来近似这个底层过程，其中参数为$theta$ :
$
bold(x) tilde p_theta (bold(x))
$
学习最常见的是一个搜索参数 $theta$ 的过程，使得由模型给出的概率分布函数 $p_theta (bold(x)) $ 近似于数据的真实分布 $p^*(bold(x)) $，即对于任何观测到的 $bold(x)$，两者尽可能接近:
$
p_theta (bold(x)) approx p^* (bold(x))
$

=== Conditional Models
在分类或者回归问题上面，我们不关心无条件模型 $p_theta (bold(x))$，更倾向于条件模型 $p_theta (y|x)$，它近似于底层的条件分布 $p^*(y|x)$：即在观测变量$bold(x)$的值上，对变量$y$的值进行分布。在这种情况下，bold(x)通常被称为模型的输入。与无条件情况类似，我们选择并优化一个模型 $p_theta (y|x)$，使其接近未知的底层分布，即对于任何 $bold(x) $ 和 $y$:

$
p_(theta)(y|bold(x)) approx p^*(y|bold(x))
$

== Directed Graphical Models and Neural Networks
#v(.9em)
我们使用有向概率图模型(Directed probability graph model)，或贝叶斯网络。有向图模型是一种概率模型，其中所有的变量被拓扑组织成一个有向无环图。这些模型的变量的联合分布被分解为先验分布和条件分布的乘积:
$
p_(theta) (bold(X)_1,...,bold(X)_M) = product_(j=1)^M p_(theta)(bold(X)_j | P_a (bold(X)_j))
$
$P_a (bold(x)_j)$ 是有向图中节点 $j$ 的父向量的集合。

== Maximum Likelihood and Minibatch SGD
#v(.9em)
概率模型最常见的标准是最大对数似然(ML). *Maximization of the log-likelihood criterion is equivalent to minimization of a Kullback Leibler divergence between the data and model distributions.*
