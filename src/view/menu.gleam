import gleam/int
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import mvu

pub fn get(model: mvu.Model) -> element.Element(mvu.Msg) {
  let income_field = get_income_field(model.income_per_round)
  let rounds_input = get_rounds_input(model.rounds)
  let odds_slider = get_odds_slider(model.success_odds)
  html.div([attribute.class("menu")], [income_field, rounds_input, odds_slider])
}

fn get_income_field(current_income: Int) -> element.Element(mvu.Msg) {
  html.label([], [
    html.text(" Income per round: "),
    html.input([
      attribute.value(current_income |> int.to_string),
      attribute.step("1"),
      attribute.id("incomeInput"),
      attribute.type_("number"),
      event.on_input(mvu.UserChangedIncome),
    ]),
  ])
}

fn get_odds_slider(current_odds: Int) -> element.Element(mvu.Msg) {
  html.label([], [
    html.text(" Odds of winning: "),
    html.input([
      attribute.value(current_odds |> int.to_string),
      attribute.step("1"),
      attribute.max("100"),
      attribute.min("0"),
      attribute.id("slider"),
      attribute.type_("range"),
      event.on_input(mvu.UserChangedOdds),
    ]),
    html.span([attribute.id("sliderValue")], [
      html.text({ current_odds |> int.to_string } <> "%"),
    ]),
  ])
}

fn get_rounds_input(current_rounds: Int) -> element.Element(mvu.Msg) {
  html.label([], [
    html.text(" Rounds: "),
    html.input([
      attribute.value(current_rounds |> int.to_string),
      attribute.step("1"),
      attribute.id("roundsInput"),
      attribute.type_("number"),
      event.on_input(mvu.UserChangedRounds),
    ]),
  ])
}
