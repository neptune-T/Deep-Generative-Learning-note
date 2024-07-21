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
- $"Chain Role:" p(x_1,x_2,···x_p) =  display(product_(i=1)^p p(x_i|x_1,x_3···x_(p-1)))$
- "$"Bayesian Rule:" p(x_2|x_1) = p(x_1,x_2)/p(x_1) = p(x_1,x_2)/(integral p(x_1,x_2) dif x_2) = (p(x_2)p(x_1|x_2))/ (integral p(x_2)p(x_1|x_2) dif x_2)$

#v(.9em)
高维随机变量的困难：
#set list (marker:text(red)[#sym.checkmark])
- 维度高,计算复杂,$p(x_1,x_2,···x_p)$的计算量太大

