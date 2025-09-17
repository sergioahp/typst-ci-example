// Hybrid CSS-in-Typst + External CSS approach
#let theme = (
  colors: (
    primary: rgb("#0090ff"),
    text: rgb("#1d1d1d"),
  )
)

// CSS injection using html.elem (cleaner approach)
#let inject-css() = context {
  if sys.inputs.at("target", default: "pdf") == "html" {
    html.elem("style", 
      "h1, h2, h3 { color: #0090ff; font-weight: 700; } svg { margin: 1.5em auto; display: block; border-radius: 8px; } body { max-width: 65ch; margin: 0 auto; padding: 2rem; } span svg { margin: 0; display: inline-block; vertical-align: middle; }"
    )
  }
}

// Automatic math equation handling with show rule
#show math.equation: it => context {
  if sys.inputs.at("target", default: "pdf") == "html" {
    if it.block {
      html.frame(it)           // Block: standalone SVG
    } else {
      box(html.frame(it))      // Inline: wrapped SVG
    }
  } else {
    it                         // PDF: native math
  }
}

// Apply CSS injection using html.elem
#inject-css()
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

== Math and Equations

Here's an inline equation: $E = m c^2$ and some display math:

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi)/2 $

The quadratic formula:
$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a) $

== More Text

This text should also appear in the HTML version.
