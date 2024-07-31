#import "template.typ": project, chapter

#show: project.with(
  title: "Convex Optimization",
  author: "ZTS",
  email: "plote5024@gmail.com",
)

#chapter("Recommended Books")

#align(center)[
  #set par(justify: true)
  Boyd. Vandenberghe.  《 Convex Optimization 》\
  Nocedal. Wright.  《 Numerical Optimization  >\
  Nesterow. 《 Introductory Lectures On Convex Optimization 》
]

#chapter("Convex Set")

$
C subset eq R ^n 
$