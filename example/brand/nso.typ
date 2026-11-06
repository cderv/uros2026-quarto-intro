// House style of the Northbridge Statistical Office (Typst)

// Figure and table captions read as headlines
#show figure.caption: set text(font: "Source Serif 4", weight: 600, size: 1.1em, fill: rgb("#7a1f3d"))
#show figure.caption: set align(left)

// Key figure: a stone box with a burgundy rule
#show figure.where(kind: "quarto-float-kf"): it => block(
  width: 100%, fill: rgb("#f6f3ee"), inset: 14pt, radius: 3pt,
  stroke: (left: 5pt + rgb("#7a1f3d")),
  align(left, it),
)
