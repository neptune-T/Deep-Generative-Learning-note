// template.typ

#let font = (
  main: "Times New Roman",
  sans: "Arial",
  mono: "Courier New",
  cjk: "SimSun",
)

#let project(title: "", author: "", email: "", logo: none, body) = {
  set document(author: author, title: title)
  set text(font: (font.main, font.cjk), size: 16pt)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
  )
  
  // Title page
  page[
    #if logo != none {
      align(center)[#image("../../img/logo.png", width: 40%)]
    }
    #v(3cm)
    #align(center)[
      #text(font: font.sans, size: 24pt, weight: "bold")[
        #title
      ]
    ]
    
    #v(1cm)
    #line(length: 100%, stroke: 0.5pt + rgb("#1252f4"))
    
    #align(right)[
      #v(1cm)
      #text(font: font.sans, size: 17pt)[
        #author
      ]
      #v(0.9cm)
      #text(font: font.sans, size: 15pt)[
        #email
      ]
    ]
    
  ]
  
  
  pagebreak()
  
  // Main body
  set par(justify: true, leading: 1.6em)
  set heading(numbering: "1")
  
  
  body
}

#let chapter(title) = {
  pagebreak(weak: true)
  align(center)[
    #block(inset: (left: 0pt, right: 0pt))[
      #text(font: font.sans, weight: "bold", size: 19pt)[
        #counter(heading).display()
        #h(0.5cm)
        #title
      ]
    ]
  ]
  line(length: 100%, stroke: 0.5pt + rgb("#1252f4"))
  v(0.5cm)
}