#import "template.typ": *
#import "@preview/physica:0.9.5": *

#show: amznotes-typst.with(
  title: "Test Document Title",
  subtitle: "Project 2",
  author: ("Silvermilight"),
)

= Overview

== Section 1

#dfnbox(name: "amznotes")[
  #dfntxt[amznotes-typst] is a typst template which imitates the style of latex template #dfntxt[amznotes].
]

#thmbox(name: "First Theorem")[
  This Typst template is cool.

  #proof[
    Here is what some math looks like:
    
    $
      forall (n in NN) [sum_(i=1)^n i = (n(n+1)) / 2]
    $

    $
      cal(L){f}(s) = integral_0^infinity e^(-s t) f(t) dd(t)
    $

    Some more math:

    $
      floor(x) &= max {n in ZZ mid(:) x <= z} \
      ceil(x)  &= min {n in ZZ mid(:) x >= z}
    $

    The math is good.
  ]
]

As seen in #nameref(refname: "thm:First Theorem") (Theorem #boxref(refname: "thm:First Theorem")), this template is pretty cool.

#codebox(name: "Test Code", refname: "test-code")[
  Here is some Python code:

  ```python
  def test_func():
      print("Hello world!")
  ```
]


=== Subsection

#notebox[
  #exbox(name: "Cool Example")[
    This is my example!
  ]
  #nameref(refname: "ex:Cool Example") (example #boxref(refname: "ex:Cool Example")) is pretty cool.
]


==== Subsubsection

== Section 2

Test Document

#link("https://www.google.com")[Google]

= Really really long chapter title that has to use more than one line because it is so long

#lorem(200)

#notebox[
  #lorem(100)
]

#lorem(200)
