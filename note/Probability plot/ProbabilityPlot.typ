#import "template.typ": project, chapter

#show: project.with(
  title: "Probability plot",
  author: "ZTS",
  email: "plote5024@gmail.com",
  logo: ""
)

#figure(
  image("/img/Probability plot.png", width:140%),
  caption: [
     Introduction to Probabilistic Graphical Models.
  ],
) 

$
  "高维随机变量" P(x_1,x_2···x_p) 
  = cases("边缘概率" p(x_i),
          "条件概率" p(x_j|x_i))
$

#set list(marker:text(blue)[#sym.checkmark])
- $ "Sum rule:"  p(x_1) =  display(integral p(x_1,x_2) dif x_2)$
- $ "Poduct Rule: " p(x_2) = p(x_1)p(x_2|x_1) = p(x_2)p(x_1|p_2)$
- $"Chain Role:" p(x_1,x_2,...x_p) =  display(product_(i=1)^p p(x_i|x_1,x_3...x_(p-1)))$
- $"Bayesian Rule:" p(x_2|x_1) = p(x_1,x_2)/p(x_1) = p(x_1,x_2)/(integral p(x_1,x_2) dif x_2) = (p(x_2)p(x_1|x_2))/ (integral p(x_2)p(x_1|x_2) dif x_2)$

#v(.9em)
高维随机变量的困难：
#set list (marker:text(red)[#sym.checkmark])
- 维度高,计算复杂,$p(x_1,x_2,···x_p)$的计算量太大


#chapter("Bayesion network")

$
P(x_1, x_2, ..., x_p) = P(x_1) dot product_(i=2)^p P(x_i | x_(1:i-1))
$

$
"条件独立性来简化依赖链过长" x_A bot x_c | x_B
$
$
"因子分解：" P(x_1, x_2, ..., x_p) = product_(i=1)^p P(x_i | x_(p_a(i)))
$

#figure(
  image("/img/bayesian Directed Graph Model.png", width:40%),
  caption: [
     Directed Graph Model.
  ],
) 
这个概率分布就可以写成：
$
p(a,b,c,d,e) = p(a)p(b|a)p(c|a,b)p(d|b)p(e|c).
$
== 怎么构建图？ -- 拓扑排序
#v(.9em)
只要存在$p(x_i|x_j)$我们就可以称$j$是$i$的父节点，$j -> i$
