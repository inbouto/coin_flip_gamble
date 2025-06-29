import compute
import config
import gleam/option.{None}
import lustre
import mvu
import side_effects
import update
import view

pub fn main() -> Nil {
  let init_data =
    compute.compute(
      config.init_rounds,
      config.init_income,
      config.initial_funds,
      config.init_odds,
    )

  let assert Ok(_) =
    lustre.application(
      fn(_) {
        let model =
          mvu.Model(
            config.initial_funds,
            config.init_income,
            config.init_odds,
            config.init_rounds,
            None,
            init_data,
          )
        #(model, side_effects.init_graph(model))
      },
      update.update,
      view.view,
    )
    |> lustre.start("#app", Nil)

  Nil
}
