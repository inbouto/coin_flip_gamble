import config
import lustre/attribute
import lustre/element
import lustre/element/html
import mvu

pub fn get(_model: mvu.Model) -> element.Element(mvu.Msg) {
  html.div([], [
    html.p([], [
      html.text(
        "Hint: click the legend boxes at the top of the graph to enable/disable some curves",
      ),
    ]),
    html.div(
      [attribute.class("graph-container"), attribute.id("graphContainer")],
      [html.canvas([attribute.id(config.canvas_id)])],
    ),
  ])
}
