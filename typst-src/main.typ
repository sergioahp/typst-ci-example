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
