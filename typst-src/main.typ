// Hybrid CSS-in-Typst + External CSS approach
#let theme = (
  colors: (
    primary: rgb("#0090ff"),
    text: rgb("#1d1d1d"),
  )
)

// Light CSS injection for HTML (only when requested)
#let inject-light-css() = context {
  if sys.inputs.at("target", default: "pdf") == "html" and sys.inputs.at("light-css", default: "false") == "true" {
    raw(block: false, "<style>h1,h2,h3{color:#0090ff;}svg{margin:1em auto;display:block;}</style>")
  }
}

// Apply light theming (no CSS injection by default)
#inject-light-css()
#set text(size: 11pt, fill: theme.colors.text)
#set heading(numbering: "1.")
#show heading.where(level: 1): set text(size: 2.25em, weight: 700, fill: theme.colors.primary)
#show heading.where(level: 2): set text(size: 1.5em, weight: 600, fill: theme.colors.primary)

= My Typst Document

This is a simple document with both text and graphics.

== Text Content

Here's some regular text that should appear in HTML export.

- First item
- Second item  
- Third item

== Graphics Section

The following graphics are created with CeTZ:

#import "@preview/cetz:0.3.4"

// Reusable function for CeTZ HTML export compatibility
#let cetz-html(body) = {
  let canvas = cetz.canvas(body)
  
  // Workaround for HTML export: wrap in html.frame
  context if sys.inputs.at("target", default: "pdf") == "html" {
    html.frame(canvas)
  } else {
    canvas
  }
}

#cetz-html({
  import cetz.draw: *
  
  circle((0, 0))
  line((0, 0), (2, 1))
})

== More Text

This text should also appear in the HTML version.
