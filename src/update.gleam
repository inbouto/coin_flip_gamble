import charts_ffi
import compute
import gleam/int
import gleam/option.{Some}
import lustre/effect
import mvu
import side_effects

pub fn update(
  model: mvu.Model,
  msg: mvu.Msg,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  case msg {
    mvu.UserChangedIncome(new_income:) -> user_changed_income(new_income, model)
    mvu.UserChangedOdds(new_odds:) -> user_changed_odds(new_odds, model)
    mvu.AppFinishedInitializing(chart:) ->
      app_finished_initializing(chart, model)
    mvu.UserChangedRounds(new_rounds:) -> user_changed_rounds(new_rounds, model)
    mvu.UserClickedTryAgain -> user_clicked_try_again(model)
  }
}

fn app_finished_initializing(
  chart: charts_ffi.Chart,
  model: mvu.Model,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  let model = mvu.Model(..model, chart: Some(chart))
  #(model, effect.none())
}

fn user_changed_income(
  new_income_string: String,
  model: mvu.Model,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  let assert Ok(new_income) = new_income_string |> int.parse
  let model = mvu.Model(..model, income_per_round: new_income)
  #(model, effect.none())
}

fn user_changed_odds(
  new_odds_string: String,
  model: mvu.Model,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  let assert Ok(new_odds) = new_odds_string |> int.parse
  let model = mvu.Model(..model, success_odds: new_odds)
  #(model, effect.none())
}

fn user_changed_rounds(
  new_rounds_string: String,
  model: mvu.Model,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  let assert Ok(new_rounds) = new_rounds_string |> int.parse
  let model = mvu.Model(..model, rounds: new_rounds)
  #(model, effect.none())
}

fn user_clicked_try_again(
  model: mvu.Model,
) -> #(mvu.Model, effect.Effect(mvu.Msg)) {
  let new_data =
    compute.compute(
      model.rounds,
      model.income_per_round,
      model.initial_funds,
      model.success_odds,
    )
  let model = mvu.Model(..model, current_data: new_data)
  let assert Some(chart) = model.chart
  charts_ffi.do_destroy_chart(chart)
  let effect = side_effects.init_graph(model)
  #(model, effect)
}
