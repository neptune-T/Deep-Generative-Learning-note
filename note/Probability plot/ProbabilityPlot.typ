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
- sum rule:p(x_i) = 
- 