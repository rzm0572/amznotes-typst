#let main-font = ("STIX Two Text", "Songti SC")
#let math-font = "STIX Two Math"
#let mono-font = "Consolas"

#let chapter-color = rgb("0984E3")
#let dfnbox-color  = rgb("0984E3")
#let thmbox-color  = rgb("6C5CE7")
#let exbox-color   = rgb("FDCB6C")
#let enbox-color   = rgb("E17055")
#let codebox-color = rgb("2D3436")
#let notebox-color = rgb("D63031")

#let dfnbox-counter = counter("dfn-counter")
#let thmbox-counter = counter("thm-counter")
#let exbox-counter  = counter("ex-counter")
#let enbox-counter  = counter("en-counter")
#let codebox-counter = counter("code-counter")
#let notebox-counter = counter("note-counter")

#let amznotes-typst(
  title: "",
  subtitle: none,
  author: (""),
  remark: none,
  date: datetime.today().display("[year] 年 [month padding:none] 月 [day padding:none] 日"),
  title-page: true,
  table-of-contents: true,
  body,
) = {
  set document(author: author, title: title)

  set text(font: main-font, size: 12pt)

  show math.equation: set text(font: math-font)

  // Title page
  if title-page {
    let author-line-spacing = 0.25em     // line spacing between author names

    v(1fr)
    align(center, text(title, font: main-font, size: 24pt, weight: "extrabold"))
    if subtitle != none {
      v(2em)
      align(center, text(subtitle, font: main-font, size: 18pt, weight: "medium"))
    }
    v(6em)

    // author list
    if type(author) == str {       // single author
      align(center, text(author, font: main-font, size: 12pt))
    } else if type(author) == array {
      for i in author {            // multiple authors
        align(center, text(i, font: main-font, size: 12pt))
        if i != author.last() {
          v(author-line-spacing)   // insert line spacing between author names
        }
      }
    }

    v(3fr)
    if remark != none {
      align(center, text(font: main-font, size: 12pt, weight: "regular", remark))
      v(1em)
    }
    align(center, text(font: main-font, size: 12pt, date))
    v(2em)

  }

  // Set heading style
  set heading(
      numbering: (..args) => {
        let nums = args.pos()
        // if nums.len() == 1 {
        //   return numbering("I  ", ..nums)
        // } else if nums.len() == 2 {
        //   return numbering("1  ", ..nums.slice(1))
        // } else {
        //   return numbering("1.1  ", ..nums.slice(1))
        // }
        return numbering("1.1  ", ..nums)
      },
    )

    show heading.where(level: 1): it => {
      pagebreak()
      layout(size => {
        let available-width = size.width
        let full-width = page.width
        let border-width = (full-width - available-width) / 2
        let vspace = 1.2em

        let number-block-width = 1.5em
        let number-block-height = 1.4em
        let is-content = counter(heading).get().at(0) == 0

        place(
          top + left,
          dx: -border-width,
          rect(
            fill: chapter-color,
            stroke: none,
            inset: (
              left : border-width, top   : vspace,
              right: border-width, bottom: vspace
            ),
            width: full-width,
          )[
            #align(
              horizon,
              text(it.body, fill: white, size: 1.4em, weight: "extrabold")
            )
          ]
        )

        if not is-content {
          place(
            top + right,
            dx: number-block-width,
            dy: -number-block-height / 2,
            rect(
              fill: chapter-color,
              stroke: white,
              radius: 5pt,
              height: number-block-height,
              inset: (left: 0.4em, right: 0.4em)
            )[
              #align(
                center + horizon,
                text(counter(heading).display("1"), fill: white, size: 1.4em, weight: "bold")
              )
            ]
          )
        }

        v(5em)
      })

      dfnbox-counter.update(0)
      thmbox-counter.update(0)
      exbox-counter.update(0)
      enbox-counter.update(0)
      codebox-counter.update(0)
      notebox-counter.update(0)
    }

    show heading.where(level: 2): it => block(
      width: 100%,
      above: 2em,
      below: 2em,
      {
        set align(center)
        set text(size: 1.2em)
        it
      },
    )

  
  // Set contents style
  if table-of-contents {
    // show outline: set heading(level: 1)
    outline(title: text("Table of Contents"), depth: 3, indent: 1.4em)
  }
  
  // Set page style
  set page(
    numbering: "1 of 1",
    number-align: center,
  )

  // Set link style
  show link: it => underline(text(fill: black, it), stroke: blue, offset: 0.18em)

  body
}

#let amzbox(it, name: "", refname: "", color: none, counter: none, boxtype: "undef") = {
  let frame-color = color.mix((color, 0.85), (black, 0.15))
  let interior-color = color.mix((color, 0.05), (white, 0.95)).transparentize(75%)
  let segmentation-color = color.mix((color, 0.5), (black, 0.5)).transparentize(75%)

  counter.step()

  if refname == "" {
    refname = name
  }

  let amzbox-block = block(
    fill: interior-color,
    stroke: none,
    radius: 3pt,
    width: 100%,
  )[
    #rect(
      fill: frame-color,
      radius: (top: 3pt),
      height: 2em,
      inset: (left: 1em, right: 1em),
      width: 100%,
      stroke: none,
      align(horizon, text(name, fill: white, size: 1em, weight: "bold"))
    ) #label(refname)
    #v(-1.2em)
    #block(
      it,
      width: 100%,
      inset: (top: 0.8em, bottom: 0.8em, left: 1em, right: 1em)
    )
  ]

  amzbox-block
}

#let dfnbox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(dfnbox-counter.get().at(0))
  let numbered-name = "Definition " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "dfn:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: dfnbox-color, counter: dfnbox-counter)
}

#let thmbox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(thmbox-counter.get().at(0))
  let numbered-name = "Theorem " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "thm:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: thmbox-color, counter: thmbox-counter)
}

#let exbox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(exbox-counter.get().at(0))
  let numbered-name = "Example " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "ex:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: exbox-color, counter: exbox-counter)
}

#let enbox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(enbox-counter.get().at(0))
  let numbered-name = "Exercise " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "en:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: enbox-color, counter: enbox-counter)
}

#let codebox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(codebox-counter.get().at(0))
  let numbered-name = "Code " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "code:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: codebox-color, counter: codebox-counter)
}

#let notebox(it, name: "", refname: "") = {
  let chapter-number = context str(counter(heading).get().at(0))
  let box-number = context str(notebox-counter.get().at(0))
  let numbered-name = "Note " + chapter-number + "." + box-number
  
  if name != "" {
    numbered-name += " ▶ " + name
  }
  
  if refname == "" {
    refname = name
  }

  refname = "note:" + refname

  amzbox(it, name: numbered-name, refname: refname, color: notebox-color, counter: notebox-counter)
}



#let boxref(refname: str) = {
  let reftype = refname.split(":").at(0)
  let reflabel = label(refname)
  let chapter-number = context str(counter(heading).at(reflabel).at(0))

  let counter = none
  if reftype == "dfn" {
    counter = dfnbox-counter
  } else if reftype == "thm" {
    counter = thmbox-counter
  } else if reftype == "ex" {
    counter = exbox-counter
  } else if reftype == "en" {
    counter = enbox-counter
  } else if reftype == "code" {
    counter = codebox-counter
  } else if reftype == "note" {
    counter = notebox-counter
  } else {
    return text(refname)
  }
  
  let box-number = context str(counter.at(reflabel).at(0))

  link(reflabel, chapter-number + "." + box-number)
}

#let dfntxt(it) = text(it, weight: "bold", style: "italic")

#let proof(it, add-divider: false) = {
  let segmentation-color = color.mix((thmbox-color, 0.5), (black, 0.5)).transparentize(75%)
  
  if add-divider {
    line(length: 100%, stroke: segmentation-color)
  }

  block(
    width: 100%,
  )[
    #text("Proof. ", style: "italic")
    #it
    #place(
      bottom + right,
      rect(
        height: 0.75em,
        width: 0.75em,
        radius: 0.2em,
        stroke: black + 0.8pt
      )
    )
  ]
}
