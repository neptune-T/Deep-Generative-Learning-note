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

== Dataset
#v(.9em)
我们收集$N≥1$个数据点组成的数据集 $cal(D)$:
$
cal(D) = {bold(x)^((1)),bold(x)^((2)),...,bold(x)^((N))} equiv {bold(x^((i)))}_(i=1)^N equiv bold(x)^((1:N))
$

数据集被认为由同一（不变）系统的独立测量值组成。在这种情况下，观测数据 $cal(D) = { bold(x)^((i))}_(i=1)^N$被称为独立同分布(i.i.d.)。在独立同分布的假设下，给定参数的情况下，数据点的概率因子化为各个数据点概率的乘积。因此，模型分配给数据的对数概率表示为：
$ 
log p_theta(cal(D)) = sum_(x in cal(D)) log p_theta(x) $
== Maximum Likelihood and Minibatch SGD
#v(.9em)
概率模型最常见的标准是最大对数似然(ML). *Maximization of the log-likelihood criterion is equivalent to minimization of a Kullback Leibler divergence between the data and model distributions.*

优化方式比较好用的方法是*_stochastic gradient descent_*

考虑一个数据集$cal(D)$包含N个数据点,我们无法每次都使用整个数据集来计算梯度，因为这样计算代价太高。因此，我们随机抽取一个小批量数据 $cal(M)$（例如，大小为$N_cal(M)$），并计算这个小批量数据上的梯度。我们希望这个小批量数据上的梯度能够在期望值上等于整个数据集上的梯度。

在随机梯度下降中，这意味着（公式推导放在1.6.1，不占用篇幅继续写结论）：

$
EE[nabla_theta log p_theta (cal(M))] = nabla_theta log p_theta (cal(D))
$
$cal(M)$是从$cal(D)$中随机抽出来的小批量数据，$log p_theta (cal(M))$是这个小批量的对数似然，$log p_theta (cal(D))$是整个数据集的对数似然。

对数似然无偏估计：

对于整个数据集 $cal(D)$，其对数似然是：
$
log p_theta (cal(D)) = sum_(x in cal(D)) log p_theta (x)
$
对于小批量数据 $cal(M)$，其对数似然是：
$
log p_theta (cal(M)) = sum_(x in cal(M)) log p_theta (x)
$
在期望上，小批量数据的对数似然可以近似整个数据集的对数似然：
$
1/N_cal(D) log p_theta (cal(D)) tilde.eq 1/N_cal(M) log p_theta (cal(M)) 
$

通过这样的迷你批次*_minibatches_*，我们可以形成最大似然准则的无偏估计：
$
1/N_cal(D) log p_theta (cal(D)) tilde.eq 1/N_cal(M) log p_theta (cal(M)) = 1/N_cal(M) sum_(x in cal(M)) log p_theta (x)
$

$
frac(1, N_cal(D)) nabla_theta log p_theta (cal(D)) tilde.eq frac(1, N_cal(M)) nabla_theta log p_theta (cal(M)) = frac(1, N_cal(M)) sum _ (x in cal(M)) nabla_theta log p_theta (x)
$

=== 小批量数据的梯度期望值等于整个数据集的梯度
#v(.9em)
假设数据集$cal(D)$有$N$个数据集，小批量$cal(M)$之中有$N_cal(M)$个数据集，并且小批量数据是从数据集中随机抽取的。

整个数据集的对数似然梯度:
$
nabla_theta log p_theta (cal(D)) = nabla_theta sum_(i=1) ^N log p_theta (x_i) = sum_(i=1) ^N nabla_theta log p_theta (x_i)
$

小批量数据的对数似然梯度：
$
nabla_theta log p_theta (cal(M)) = N/N_cal(M) sum_(j=1)^N_cal(M) nabla_theta log p_theta(x_j)
$
这里乘以$N/N_cal(M)$证明写在1.6.1.1了，这里就不占篇幅继续向下推导了。

假设我们抽取了$N_cal(M)$个样本，样本是独立同分布的，我们可以用数学期望来表示这种抽样过程：

$
EE[nabla_theta log p_theta (cal(M))] = EE [N/N_cal(M) sum _(j=1)^N_(cal(M)) nabla_theta log p_theta (x_j)]
$

由于 $cal(M)$ 中的样本是独立同分布的，所以:

$
EE[sum_(j=1)^(N_cal(M)) nabla_theta log p_theta (x_j)] = N_cal(M) EE [nabla_theta log p_theta (x)]
$

其中$x$是从$cal(D)$中随机抽取的一个样本。因此:

$
EE[nabla_theta log p_theta (cal(M))] 
    &= EE [N/N_cal(M) sum _(j=1)^N_(cal(M)) nabla_theta log p_theta (x_j)]\
    &= N/N_cal(M) N_cal(M) EE[nabla_theta log p_theta (x)]\
    &= N EE [nabla_theta log p_theta (x)]
$
由于数据点 $x$ 是从整个数据集中抽取的，所以 $EE[nabla_theta log p_theta (x)]$ 实际上就是总体梯度的平均值：
$
N EE [nabla_theta log p_theta (x)] = sum_(i=1)^N nabla_theta log p_theta (x_i) = nabla_theta log p_theta (cal(D))
$


==== Coefficient proof
#v(.9em)
是为了补偿小批量数据与整个数据集的大小差异，使得梯度估计在期望值上保持一致。这里乘系数的原因是：

+ 比例调整：由于小批量数据 $cal(M)$ 只是整个数据集 $cal(D)$ 的一个子集，其样本数量 $N_cal(M)$ 小于 $N$。乘以比例系数可以调整小批量数据的梯度估计，使其在期望上与整个数据集的梯度一致。
+ 无偏估计：这种调整确保了小批量数据梯度估计的期望值等于整体数据集的梯度，从而在期望上保持无偏。

定义整个数据集的对数似然梯度：
$
nabla_theta log p_theta (cal(D)) = nabla_theta sum_(i=1) ^N log p_theta (x_i) = sum_(i=1) ^N nabla_theta log p_theta (x_i)
$
定义小批量数据的对数似然梯度：
$
nabla_theta log p_theta (cal(M)) =  sum_(j=1)^N_cal(M) nabla_theta log p_theta (x_j)
$

现在假设我们从数据集中随机抽取小批量数据 $cal(M)$ ,由于 $cal(M)$ 中的数据点是独立同分布的，我们有:

$
EE [nabla_theta log p_theta (cal(M))] = EE[sum_(j=1)^N_cal(M) nabla_theta log p_theta (x_j)] = N_cal(M)EE [nabla_theta log p_theta (x)]
$
为了使小批量数据的梯度在期望上等于整个数据集的梯度，我们需要将小批量数据的梯度进行比例调整。我们定义调整后的梯度估计为：

$
tilde(nabla)_theta log p_theta (cal(M)) = N/N_M sum_(j=1)^(N_M) nabla_theta log p_theta (x_j)
$

我们现在计算这个调整后的梯度的期望值：
$
bb(E)[tilde(nabla)_theta log p_theta(cal(M))] 
&= bb(E)[N/N_M sum_(j=1)^(N_M) nabla_theta log p_theta (x_j)]\
&= N/N_M bb(E)[sum_(j=1)^(N_M) nabla_theta log p_theta (x_j)] \
&= N/N_M N_M bb(E)[nabla_theta log p_theta (x)] \
&= N bb(E)[nabla_theta log p_theta (x)]
$
由于$x$是从整个数据集中随机抽取的样本，我们有:
$
N EE [nabla_theta log p_theta (x)] = sum_(i=1)^N nabla_theta log p_theta (x_i) = nabla_theta log p_theta (cal(D))
$

== Learning and Inference in Deep Latent Variable Models
#v(.9em)

=== Latent Variables
#v(.9em)
我们可以将前一节讨论的完全观测有向模型扩展到包含潜变量的有向模型。潜变量是模型的一部分，但我们并不观测到它们，因此它们不属于数据集的一部分。我们通常用 $bold(z)$ 来表示这样的潜变量。在无条件建模观测变量 $bold(x)$ 的情况下，有向图模型将表示一个观测变量 $bold(x)$ 和潜变量 $bold(z)$ 的联合分布 $p_theta (bold(x)|bold(z))$。观测变量 $bold(x)$ 的边缘分布由以下公式给出：
$
p_theta = integral p_theta (bold(x),bold(z)) dif bold(z)
$
这也被称为（单个数据点的）边缘似然或模型证据，当它作为 $theta$ 的函数时。

这种关于 $bold(x)$ 的隐式分布可能是非常灵活的。如果 $bold(z)$ 是离散的，并且 $p_theta = (bold(x)|bold(z))$ 是一个高斯分布，那么 $p_theta (bold(x))$ 就是一个高斯混合分布。对于连续的 $bold(z)$,  $p_theta (bold(x))$ 可以看作是一个无限混合，这种混合潜在地比离散混合更强大。这样的边缘分布也称为复合概率分布。

=== Deep Latent Variable Models
#v(.9em)
*_deep latent variable model_ (DLVM) *


表示那些分布由神经网络参数化的潜变量模型 $p_theta (bold(x), bold(z) )$ 。这样的模型可以基于某些上下文条件，如  $p_theta (bold(x),bold(z) | bold(y))$。DLVM 的一个重要优势是，即使有向模型中的每个因子（先验或条件分布）相对简单（例如条件高斯分布），其边缘分布 $p_theta (bold(x)) $ 也可以非常复杂，即包含几乎任意的依赖关系。这种表达能力使得深度潜变量模型在近似复杂的底层分布 $ p^*(bold(x))$ 时非常有吸引力。

或许最简单也是最常见的 DLVM 是通过以下结构指定的分解模型：

$ 
p_theta (bold(x), bold(z)) = p_theta (bold(z)) p_theta (bold(x)|bold(z)) 
$
其中, $p_theta (bold(z))$ 和 $p_theta (bold(x)|bold(z) $ 是已知的。分布 $p(bold(z))$ 通常被称为潜变量 $bold(z)$ 的先验分布，因为它不以任何观测数据为条件。


== Intractabilities
#v(.9em)
dlvm中最大似然学习的主要困难是*the marginal probability of data under the model*通常难以处理。

由于计算边际似然(或模型证据)的方程中的积分，$p_theta (x) = integral p_θ (x, z) dif z$， *not having an
analytic solution or efficient estimator.*。由于这种不可解性，我们不能对其参数进行微分并优化它，就像我们对完全观测模型所做的那样。计算边缘似然*Need to integrate high-dimensional space*，这在实践中是非常困难的。所以在 MLE 中，我们需要最大化数据在模型下的概率。对于 DLVMs，这涉及到计算边缘似然 $p_theta (x)$，但由于其不可解性，直接进行 MLE 是不现实的。由于直接计算边缘似然是不可行的，我们通常使用变分推断（*Variational Inference*）或马尔可夫链蒙特卡罗（*MCMC*）方法来近似后验分布。这些方法通过引入可解的近似来处理不可解的积分问题。同样，神经网络参数化的(有向模型) $p(theta|cal(D))$ 的后验通常难以精确计算，需要近似推理技术。


= Variational Autoencoders
#v(.9em)
== Encoder or Approximate Posterior
#v(.9em)
dlvm估计这种模型中的对数似然分布和后验分布的问题。变分自编码器(VAEs)框架提供了一种计算效率高的方法来优化dlvm，并结合相应的推理模型使用SGD进行优化。
为了将DLVM的后验推理和学习问题转化为可处理的问题，我们引入了一个参数推理模型 $q_(phi.alt) (z|x)$。这个模型也被称为编码器或识别模型。用 $phi.alt$ 表示该推理模型的参数，也称为变分参数。我们优化变分参数 $phi.alt$:

$
q_(phi.alt) (bold(z)|bold(x)) approx p_theta (bold(z)|bold(x))
$
像DLVM一样，推理模型可以是(几乎)任何有向图形模型:
$
q_(phi.alt) (bold(z)|bold(x)) = q_(phi.alt) (bold(z)_1,...,bold(z)_M |bold(x)) = product_(j=1)^M q_(phi.alt) (bold(z)_j | P_a (bold(z)_j),bold(x)) 
$
$P_a (bold(z)_j)$ 是变量 $bold(z)_j$ 在有向图中的父变量集合。与DLVM类似，分布 $q_(phi.alt)(bold(z)|bold(x))$ 可以使用深度神经网络参数化。

$
(mu,log sigma) = "EncoderNeuralNet"_(phi.alt) (x)
$

$
q_(phi.alt) (bold(z)|bold(x)) = cal(N) (z;mu,"diag"(sigma))
$
我们使用单个编码器神经网络对数据集中的所有数据点执行后验推理。这可以与更传统的变分推理方法形成对比，其中变分参数不是共享的，而是每个数据点单独迭代优化的。通过平摊推理，我们可以避免每个数据点的优化循环，并利用SGD的效率。
#v(4em)
== Evidence Lower Bound (ELBO)
#v(1em)
#figure(
  image("../../img/vae.png", width:70%),
  caption: [
    It shows how to learn and generate new data through mapping between latent variable space ($cal(z)$-space) and observed data space ($cal(x)$-space).
  ],
) 
VAE 通过编码器和解码器网络，利用先验分布、后验近似和重建分布，实现对复杂数据分布的近似建模和生成。
#v(6em)
变分参数$phi.alt$:
$
log p_theta (bold(x)) &= EE_(q_(phi.alt)(bold(z)|bold(x))) [log p_theta (x)]\
                 &= EE_(q_(phi.alt)(bold(z)|bold(x))) [log [(p_theta (bold(x),bold(z)))/ (p_theta (bold(z)|bold(x)))]]\
                 &= EE_(q_(phi.alt)(bold(z)|bold(x))) [log [(p_theta (bold(x),bold(z)))/ (q_(phi.alt) (bold(z)|bold(x))) (q_(phi.alt) (bold(z)|bold(x)))/(p_theta (bold(z)|bold(x)))]]\
                 &= underbrace(
                    EE_(q_(phi.alt)(bold(z)|bold(x))) [log [(p_theta (bold(x),bold(z)))/ (q_(phi.alt) (bold(z)|bold(x) ))]], 
                    
                    = cal(L)_theta.. phi.alt(x)\
                    ("ELBO")
                    ) 
                    +
                    underbrace(
                    EE_(q_(phi.alt)(bold(z)|bold(x))) [log [(q_(phi.alt) (bold(z)|bold(x)))/(p_theta (bold(z)|bold(x))) ]],
                    =D_"KL" (q_(phi.alt) (bold(z)|bold(x))||p_theta (bold(z)|bold(x)) )
                    )
$
第二项是$q_(phi.alt) (z|x)$与$p_θ (z|x)$之间的*Kullback-Leibler (KL)*散度是非负的,当等于0时,$q_(phi.alt)(z|x)$ 等于真实后验分布:
$
D_"KL" (q_(phi.alt) (bold(z)|bold(x))||p_theta (bold(z)|bold(x)) ) >= 0
$

第一项是变分下界，也称为证据下界(ELBO):
$
cal(L)_(theta,phi.alt) (bold(x)) = EE_(q_(phi.alt)(bold(z|bold(x)))) [log p _theta (bold(x),bold(z)) - log q_(phi.alt) (bold(z)|bold(x))]
$
由于KL散度的非负性，ELBO是数据的对数似然的下界:
$
cal(L)_(theta,phi.alt) (bold(x)) &= log p_theta (bold(x)) -D_"KL" (q_(phi.alt) (bold(z)|bold(x))||p_theta (bold(z)|bold(x)) )\
&<=log p_theta (bold(x)) 
$



== Stochastic Gradient-Based Optimization of the ELBO
#v(.9em)
ELBO的一个重要性质是，它允许使用随机梯度下降(SGD)对所有参数( $phi.alt$ 和 $theta$ )进行联合优化。

我们可以从$phi.alt$和$theta$的随机初始值开始，随机优化它们的值，直到收敛。

$
cal( L ) _ ( theta, phi.alt ) ( cal( D ) ) = sum _ ( bold( upright( x ) ) in cal( D ) ) cal( L ) _ ( theta, phi.alt ) ( bold( upright( x ) ) )
$

一般来说，单个数据点ELBO及其梯度 $nabla_(theta,phi.alt) cal(L)_(theta,phi.alt)(x)$ 是难以处理的。然而，正如我们将展示的那样，存在良好的无偏估计量$tilde(nabla)_(theta,phi.alt)cal(L)_(theta,phi.alt)(x) $，这样我们仍然可以执行小批量SGD。生成模型参数$theta$下ELBO的无偏梯度很容易得到:

$
nabla _ ( theta ) cal( L ) _ ( theta ) cal( L ) _ ( theta, phi.alt ) ( bold( upright( x ) ) ) 
    & = nabla _ ( theta ) bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) ) ) [ log p _ ( theta ) ( bold( upright( z ) ), bold( upright( z ) ) ) ] \ 
    & = bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( z ) ) ) ) [ nabla _ ( theta ) ( log p _ ( theta ) ( bold( upright( x ) ), bold( upright( z ) ) ) - log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( z ) ) ) ) ] \ 
    & "Monte Carlo"\
    & tilde.eq nabla _ ( theta ) ( log p _ ( theta ) ( bold( upright( x ) ), bold( upright( z ) ) ) - log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) ) \ 
    & = nabla _ ( theta ) ( log p _ ( theta ) ( bold( upright( x ) ), bold( upright( z ) ) )
$

== Reparameterization Trick
#v(.9em)
对于连续潜变量和可微编码器和生成模型，可以通过变量的变化直接对ELBO进行$phi.alt$和$theta$的微分，也称为重参数化技巧。

=== Change of variables
#v(.9em)
首先，我们将随机变量 $bold( upright( z ) ) tilde q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) $表示为另一个随机变量 $ epsilon.alt$ 的可微(可逆)变换，给定$z$和$phi.alt$:
$
bold( upright( z ) ) = g ( epsilon.alt, phi.alt, bold( upright( x ) ) )
$
其中，随机变量 $ϵ$ 的分布与 $x$ 或 $𝜙$ 无关。这一步的目的是将随机变量 $cal(z)$ 表示为一种可微分的方式，从而使得梯度可以有效地计算。

重新参数化技巧的主要优势在于它将不可微分的采样过程转化为可微分的参数化过程，从而使得梯度下降优化成为可能。

#block(
  width: 100%,
  fill: white,
  inset: 8pt,
  stroke: 0.5pt,
  [
    *Algorithm 1*: 
    ELBO的随机优化。由于噪声来源于小批量采样和$p(epsilon)$的采样，因此这是一个双重随机优化过程。我们也把这个过程称为自动编码变分贝叶斯(AEVB)_the Auto-Encoding Variational Bayes_算法。

    *Data:*
    - $cal(D)$: Dataset
    - $q_phi.alt (z|x)$: Inference model
    - $p_theta (x,z)$: Generative model

    *Result:*
    - $theta, phi.alt$: Learned parameters

    $(theta, phi.alt) arrow.l$ Initialize parameters \
    *while* SGD not converged *do* \
    $quad cal(M) tilde cal(D)$ (Random minibatch of data) \
    $quad epsilon tilde p(epsilon)$ (Random noise for every datapoint in $cal(M)$) \
    $quad$ Compute $tilde(cal(L))_(theta,phi.alt)(cal(M),epsilon)$ and its gradients $nabla_(theta,phi.alt) tilde(cal(L))_(theta,phi.alt)(cal(M),epsilon)$ \
    $quad$ Update $theta$ and $phi.alt$ using SGD optimizer \
    *end*
  ]
)

=== Gradient of expectation under change of variable
#v(1em)
在变量变换的基础上，我们可以将期望用新的随机变量 $epsilon$ 表示：
$
bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) ) ) [ f ( bold( upright( z ) ) ) ] = bb( E ) _ ( p ( epsilon.alt ) ) [ f ( bold( upright( z ) ) ) ]
$

其中，$bold(z)=g(epsilon,phi.alt,bold(x))$。通过这种变换，期望运算符和梯度运算符变得可交换，我们可以进行简单的蒙特卡罗估计:

$
nabla _ ( phi.alt ) bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) ) ( bold( upright( z ) ) ) ) [ f ( bold( upright( z ) ) ) ] 
    & = nabla _ ( phi.alt ) bb( E ) _ ( p ( epsilon.alt ) ) [ f ( bold( upright( z ) ) ) ] 
$
由于 $z$ 是 $epsilon, phi, x$ 的可微函数，我们可以交换梯度运算符和期望运算符,然后通过从 $p(epsilon)$ 中采样 $epsilon$，我们可以得到对梯度的近似估计：
$
nabla _ ( phi.alt ) bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) ) ( bold( upright( z ) ) ) ) [ f ( bold( upright( z ) ) ) ] 
    & = bb( E ) _ ( p ( epsilon.alt ) ) [ nabla _ ( phi.alt ) f ( bold( upright( z ) ) ) ] \ 
    & tilde.eq nabla _ ( phi.alt ) f ( bold( upright( z ) ) )
$


#figure(
  image("../../img/epsilon.png", width:100%),
  caption: [This image illustrates the reparameterization trick, a critical technique in variational autoencoders (VAEs) for efficient gradient-based optimization. The trick allows us to rewrite the sampling process of latent variables in a differentiable manner.
    .
  ],
) 

#let body-text = 10pt
#let summary-text = 11pt

图 2 展示了重新参数化技巧的工作原理，主要包括以下两个部分：原始形式和重新参数化形式。
#grid(
  columns: (5fr, 5fr),
  gutter: 16pt,

  column-gutter: 0fr,
  [
    #text(size: body-text)[
      #set list(marker: text(green)[#sym.bullet])
      左图：原始形式（Original form）
      + 节点表示：
        - *灰色节点（Deterministic node）*：表示确定性节点，如目标函数 $f$。
        - *蓝色节点（Random node）*：表示随机节点，如潜变量 $z$。

      + 图示描述：
        - 随机变量 $z$ 从推断模型 $q_phi.alt (z|x)$ 中采样。
        - 目标函数 $f$ 依赖于 $z$ 和参数 $phi.alt$。

      2. 问题：
        - 我们希望对目标函数 $f$ 求梯度以优化参数 $phi.alt$。
        - 由于 $z$ 是从 $q_phi.alt (z|x)$ 中采样的，无法直接对 $z$ 进行反向传播，从而无法对 $phi$ 求导。

    ]
  ],

  [
    #text(size: body-text)[
      #set list(marker: text(blue)[→])
      右图：重新参数化形式（Reparameterized form）

      1. 节点表示：
        - *灰色节点（Deterministic node）*：表示确定性节点，如目标函数 $f$。
        - *蓝色节点（Random node）*：表示随机节点，如噪声 $epsilon$。

      2. 图示描述：
        - 将随机变量 $z$ 表示为 $epsilon, phi.alt, x$ 的可微函数： $z = g(phi.alt, x, epsilon)$。
        - $epsilon$ 是从简单的分布 $p(epsilon)$ 中采样的随机噪声。

      3. 梯度计算：
        - 由于 $z$ 现在是 $epsilon, phi.alt, x$ 的可微函数，我们可以对 $z$ 进行反向传播。
        - 这使得我们可以对参数 $phi.alt$ 求导并优化目标函数 $f$。
    ]
  ]
)

重新参数化技巧的步骤

  1. 变量变换：将潜变量 $z$ 表示为噪声 $epsilon$ 和参数 $phi.alt$、观测数据 $x$ 的可微函数：$z = g(epsilon, phi.alt,x)$。
  2. 期望重写：利用变量变换，将期望用新的随机变量 $epsilon$ 表示：$EE_q_phi.alt(z|x) [f(z)] = EE_p(epsilon) [f(z)]$。
  3. 梯度计算：交换梯度运算符和期望运算符，使用蒙特卡罗采样近似期望，从而计算梯度。

重新参数化技巧的优势

- 使梯度计算可行：通过将采样过程外部化，使得梯度可以通过反向传播进行计算。
- 提高计算效率：简化梯度计算过程，使用蒙特卡罗采样进行近似估计。

=== Gradient of ELBO
#v(.9em)
在重新参数化的情况下，我们可以替换期望 $q_phi.alt (z|x)$与一个$p (epsilon)$。ELBO可以重写为:
$
cal( L ) _ ( theta, phi.alt ) ( x ) & = bb( E ) _ ( q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) ) [ log p _ ( theta ) ( bold( upright( x ) ), bold( upright( z ) ) ) - log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( z ) ) ) ] \ & = bb( E ) _ ( p ( epsilon.alt ) ) [ log p _ ( theta ) ( bold( upright( x ) ), bold( upright( z ) ) ) - log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) ]
$
因此，我们可以形成单个数据点ELBO的简单蒙特卡罗估计量$tilde( cal( L ) ) _ ( theta, phi.alt ) ( x )$，其中我们使用来自$p(epsilon)$的单个噪声样本$epsilon$:
$
epsilon.alt tilde p ( epsilon.alt ) \ z = g ( phi.alt, x, epsilon.alt ) \ tilde( L ) _ ( theta, phi.alt ) ( x ) = log p _ ( theta ) ( x, z ) - log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) )
$
这一系列操作可以在TensorFlow等软件中表示为符号图，并毫不费力地微分参数θ和φ.

该算法最初被称为_Auto-Encoding Variational Bayes _(AEVB)算法。更一般地说，重新参数化的ELBO估计被称为随机梯度变分贝叶斯_(SGVB)_估计。这个估计器也可以用来估计模型参数的后验.

=== Computation of log qφ(z|x)
#v(.9em)
ELBO(估计量)的计算需要计算密度对数$q_phi.alt (z|x)$，给定值$x$，并给定值$z$或等价的$epsilon$。这个对数密度是一个简单的计算，只要我们选择正确的变换$g()$。

注意，我们通常知道密度$p(epsilon)$，因为这是所选噪声分布的密度。只要$g(.)$是可逆函数，则$epsilon$和$z$的密度关系式为:

(通过变量变换和概率密度函数的性质推导出来的,见2.4.4.1)
$
log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = log p ( epsilon.alt ) - log d _ ( phi.alt ) ( bold( upright( x ) ), epsilon.alt )
$
其中第二项是雅可比矩阵$(diff_z/diff_epsilon)$的行列式绝对值的对数,包含了从 $epsilon$ 到 $cal(z)$ 变换的所有一阶导数:
$
log d _ ( phi.alt ) ( bold( upright( x ) ), epsilon.alt ) = log abs( det ( ( diff bold( upright( z ) ) ) / ( diff epsilon.alt ) ) )
$



$
( diff bold( upright( z ) ) ) / ( diff epsilon.alt ) = ( diff ( z _ ( 1 ),..., z _ ( k ) ) ) / ( diff ( epsilon.alt _ ( 1 ),..., epsilon.alt _ ( k ) ) ) = mat( ( diff z _ ( 1 ) ) / ( diff epsilon.alt _ ( 1 ) ),..., ( diff z _ ( 1 ) ) / ( diff epsilon.alt _ ( k ) ) ; dots.v, dots.down, dots.v ; ( diff z _ ( k ) ) / ( diff epsilon.alt _ ( 1 ) ),..., ( diff z _ ( k ) ) / ( diff epsilon.alt _ ( k ) ) )
$


==== deduce
#v(.9em)
假设我们有一个随机变量 $z$，它通过一个可微且可逆的变换 $g$ 由随机变量 $ϵ$ 得到，即：
$
bold( upright( z ) ) = g ( epsilon.alt, phi.alt, bold( upright( x ) ) )
$
根据概率密度函数的变换性质，如果 $z=g(epsilon)$，那么 $z$ 的概率密度函数 $q_phi.alt (z|x)$ 和 $epsilon$ 的概率密度函数 $p(epsilon)$ 之间有如下关系：
$
q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = p ( epsilon.alt ) abs( det ( ( diff epsilon.alt ) / ( diff bold( upright( z ) ) ) ) )
$

但是，因为我们通常是知道 $(diff z)/(diff epsilon)$ 而不是 $(diff epsilon)/(diff z)$，我们需要使用雅可比行列式的逆关系：
$
abs( det ( ( diff epsilon.alt ) / ( diff z ) ) ) = ( 1 ) / ( abs( det ( ( diff z ) / ( diff epsilon.alt ) ) ) )
$
密度关系表示:
$
q _ ( phi.alt ) ( bold( upright( z ) ) )  = p ( epsilon.alt ) abs( det ( ( diff epsilon.alt ) ( diff z ) ) ) = p ( epsilon.alt ) abs( ( 1 ) / ( det ( ( diff epsilon.alt ) / ( diff epsilon.alt ) ) ) ) 
$
$ 
q _ ( phi.alt ) ( bold( upright( z ) ) ) & = p ( epsilon.alt ) abs( det ( ( diff z ) / ( diff epsilon.alt ) ) ) ^ ( - 1 )
$

== Factorized Gaussian posteriors
#v(.9em)
一个常见的选择是一个简单的_ factorized Gaussian encoder_
$
q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = cal( N ) ( bold( upright( z ) ) ; mu, op( upright( d i a g ) ) ( sigma ^ ( 2 ) ) )
$
其中，$mu$ 和 $log sigma$ 通过一个编码器神经网络 
$"EncoderNeuralNet"_phi.alt (x)$获得：
$
 q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = cal( N ) ( bold( upright( z ) ) ; mu, op( upright( d i a g ) ) ( sigma ^ ( 2 ) ) )
$
后验分布因子化为每个潜在变量 $cal(z)_i$  的高斯分布的乘积：
$
q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = product _ ( i ) q _ ( phi.alt ) ( z _ ( i ) | bold( upright( x ) ) ) = product _ ( i ) cal( N ) ( z _ ( i ) ; mu _ ( i ), sigma _ ( i ) ^ ( 2 ) )
$
将高斯随机变量 $z$ 表示为标准正态分布 $epsilon$ 经过线性变换的结果：
$
epsilon.alt tilde cal( N ) ( 0, bold( upright( I ) ) ) 
$
$ 
( mu, log sigma ) = E n c o d e r N e u r a l N e t _ ( phi.alt ) ( bold( upright( x ) ) ) 
$
$ 
bold( upright( z ) ) = mu + sigma dot.circle epsilon.alt
$
从 $ϵ$ 到 $z$ 的变换的雅可比矩阵是对角矩阵，其对角线元素是 $σ$:
$
(diff z)/(diff epsilon) = d i a g (sigma)
$
对角矩阵的行列式是其对角线元素的乘积，因此其对数行列式是对角线元素的对数之和：
$
log d _ ( phi.alt ) ( bold( upright( x ) ), epsilon.alt ) = log abs( det ( ( diff bold( upright( z ) ) ) / ( diff epsilon.alt ) ) ) = sum _ ( i )  log sigma _ ( i )
$
后验密度为:
$
log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) & = log p ( epsilon.alt ) - log d _ ( phi.alt ) ( bold( upright( x ) ), epsilon.alt ) \ & = sum _ ( i ) log cal( N ) ( epsilon.alt _ ( i ) ; 0, 1 ) - log sigma _ ( i )
$

=== Full-covariance Gaussian posterior
#v(.9em)
因式高斯后验可以推广为具有全协方差的高斯:
$
q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = cal( N ) ( bold( upright( z ) ) ; bold( upright( mu ) ), bold( upright( Sigma ) ) )
$
该分布的重新参数化由下式给出:
$
epsilon.alt tilde cal( N ) ( 0, bold( upright( I ) ) ) \ bold( upright( z ) ) = mu + bold( upright( L ) ) epsilon.alt
$
其中 $bold(L)$ 是下(或上)三角矩阵，在对角线上有非零元素。非对角线元素定义了 $z$ 中元素的相关性(协方差)。对于这种全协方差高斯模型，雅可比行列式很简单，因为：
$
(diff z)/(diff epsilon) = bold(L)
$
因为 $bold(L)$ 是下(或上)三角矩阵，所以行列式是其对角线元素的乘积:
$
log abs( det ( ( diff bold( upright( z ) ) ) / ( diff epsilon.alt ) ) ) = sum _ ( i ) log abs( L _ ( i i ) )
$
后验密度的对数计算为：
$
log q _ ( phi.alt ) ( bold( upright( z ) ) | bold( upright( x ) ) ) = log p ( epsilon.alt ) - sum _ ( i ) log abs( L _ ( i i ) )
$
协方差矩阵 $Σ$ 可以通过 Cholesky 分解得到：
$
Sigma = bold( upright( L ) ) bold( upright( L ) ) ^ ( T )
$
协方差矩阵 $sum$ 的计算过程为：
$
Sigma = bb( E ) [ ( bold( upright( z ) ) - bb( E ) [ bold( upright( z ) ) ] ) ( bold( upright( z ) ) - bb( E ) [ bold( upright( z ) ) ] ) ^ ( T ) ]
$
通过引入 $epsilon$，我们有:
$
Sigma = bb( E ) [ ( bold( upright( z ) ) - bb( E ) [ bold( upright( z ) ) ] ) ( bold( upright( z ) ) - bb( E ) [ bold( upright( z ) ) ] ) ^ ( T ) ]
$
由于 $epsilon.alt tilde cal( N ) ( 0, bold( upright( I ) ) )$ 有：
$
bb( E ) [ epsilon.alt epsilon.alt ^ ( T ) ] = bold( upright( I ) )
$
通过神经网络获取参数 $mu$ ,$log sigma$和 $bold(L)'$ ：
$
( mu, log sigma, bold( upright( L )' ) )  <- E n c o d e r N e u r "Net" _ ( phi.alt ) ( bold( upright( x ) ) ) 
$
构建$bold(L)$矩阵:
$
L <- bold( upright( L ) ) _ ( m a s k ) dot.circle bold( upright( L ) ) ^ ( zwj' ) + "diag" ( sigma )
$
$bold(L)_(m a s k)$是一个掩码矩阵，其对角线下方的元素为1，对角线和对角线上方的元素为0。

对于因子化高斯情形，后验密度的对数计算为：
$
log abs( det ( ( diff bold( upright( z ) ) ) / ( diff epsilon.alt ) ) ) = sum _ ( i ) log sigma _ ( i )
$

#block(
  width: 100%,
  fill: white,
  inset: 8pt,
  stroke: 0.5pt,
  [
    *Algorithm 2*: 
    单数据点ELBO无偏估计的计算，用于具有全协方差高斯推理模型和因子化伯努利生成模型的VAE示例。$L_("mask")$是一个掩蔽矩阵，对角线上及以上为零，对角线下为一。

    *Data:*
    - $x$: : a datapoint, and optionally other conditioning information
    - $epsilon$: a random sample from $p(epsilon) = cal(N)(0,I)$ 
    - $theta$:  Generative model parameters
    - $phi.alt$: Inference model parameters
    - $q_phi.alt(z|x)$: Inference model
    - $p_theta(x,z)$: Generative model


    *Result:*
    - $tilde(cal(L))$: 单数据点ELBO $cal(L)_(theta,phi.alt)(x)$ 的无偏估计
    #v(.9em)
    $(mu, log sigma, bold(L')) arrow.l "EncoderNeuralNet"_phi.alt (x)$ \
    $bold(L) arrow.l bold(L)_(m a s k) dot.circle bold(L') + d i a g (sigma)$ \
    $epsilon tilde cal(N)(0,I)$ \
    $z arrow.l bold(L) epsilon + mu$ \
    $tilde(cal(L))_("logqz") arrow.l - sum_i (1/2(epsilon_i^2 + log(2pi) + log sigma_i))_i$
    #h(1fr) 
    $triangle.r = q_phi.alt (z|x)$ \
    $tilde(cal(L))_("logpz") arrow.l - sum_i (1/2(z_i^2 + log(2pi)))$
    #h(1fr) 
    $triangle.r = p_theta (z)$ \
    $p arrow.l "DecoderNeuralNet"_theta (z)$ \
    $tilde(cal(L))_("logpx") arrow.l sum_i (x_i log p_i + (1 - x_i) log(1 - p_i))$ 
    #h(1fr) 
    $triangle.r = p_theta (x|z)$ \
    $tilde(cal(L)) = tilde(cal(L))_("logpx") + tilde(cal(L))_("logpz") - tilde(cal(L))_("logqz")$
  ]
)




