import charts_ffi
import gleam/option.{type Option}

pub type Model {
  Model(
    initial_funds: Int,
    income_per_round: Int,
    success_odds: Int,
    rounds: Int,
    chart: Option(charts_ffi.Chart),
    current_data: List(#(String, String, charts_ffi.ChartData)),
  )
}

pub type Msg {
  AppFinishedInitializing(chart: charts_ffi.Chart)
  UserChangedIncome(new_income: String)
  UserChangedOdds(new_odds: String)
  UserChangedRounds(new_rounds: String)
  UserClickedTryAgain
}
