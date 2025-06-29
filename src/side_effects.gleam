import charts_ffi
import config
import gleam/javascript/array
import lustre/effect
import mvu

pub fn init_graph(model: mvu.Model) -> effect.Effect(mvu.Msg) {
  use dispatch, _ <- effect.before_paint()
  charts_ffi.do_init_chart(
    config.canvas_id,
    model.current_data |> array.from_list,
  )
  |> mvu.AppFinishedInitializing
  |> dispatch
}
