import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import mvu

pub fn get(_model: mvu.Model) -> element.Element(mvu.Msg) {
  html.button(
    [
      event.on_click(mvu.UserClickedTryAgain),
      attribute.class("try-again-button"),
    ],
    [html.text("Reload")],
  )
}
