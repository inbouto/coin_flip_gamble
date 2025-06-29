import lustre/element
import lustre/element/html
import mvu
import view/graph
import view/menu
import view/strategies_explained
import view/try_again

pub fn view(model: mvu.Model) -> element.Element(mvu.Msg) {
  let menu = menu.get(model)
  let graph = graph.get(model)
  let try_again = try_again.get(model)
  let strategies_explained = strategies_explained.get(model)
  let title = html.h1([], [html.text("Coin flip gambling odds simulator")])
  let content = [title, menu, graph, try_again, strategies_explained]
  html.div([], content)
}
