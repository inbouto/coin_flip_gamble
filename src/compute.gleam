import charts_ffi
import config
import gleam/int
import gleam/javascript/array
import gleam/list
import gleam/yielder
import prng/random

pub type Tosses =
  yielder.Yielder(Bool)

pub type GamblingResults =
  yielder.Yielder(#(Int, Int))

pub type Strategy {
  Strategy(name: String, color: String, run: fn(Int, Int) -> Int)
}

pub fn compute(
  rounds rounds: Int,
  income income_per_round: Int,
  funds initial_funds: Int,
  odds odds: Int,
) -> List(#(String, String, charts_ffi.ChartData)) {
  let never_bet_strategy: Strategy =
    Strategy(config.never_bet_name, config.never_bet_color, never_bet)
  let always_same_bet_strategy: Strategy =
    Strategy(
      config.always_same_bet_name,
      config.always_same_bet_color,
      always_same_bet,
    )

  let always_all_in: Strategy =
    Strategy(
      config.always_all_in_name,
      config.always_all_in_color,
      always_all_in,
    )

  let slow_and_steady: Strategy =
    Strategy(
      config.slow_and_steady_name,
      config.slow_and_steady_color,
      slow_and_steady,
    )

  let all_in_with_limit_fn = fn(one, two) {
    all_in_with_limit(one, two, config.all_in_with_limit_limit)
  }

  let all_in_with_limit: Strategy =
    Strategy(
      config.all_in_with_limit_name,
      config.all_in_with_limit_color,
      all_in_with_limit_fn,
    )

  let all_in_then_quit_fn = fn(one, two) {
    all_in_then_quit(one, two, config.all_in_then_quit_limit)
  }

  let all_in_then_quit: Strategy =
    Strategy(
      config.all_in_then_quit_name,
      config.all_in_then_quit_color,
      all_in_then_quit_fn,
    )

  let strategies = [
    never_bet_strategy,
    always_same_bet_strategy,
    slow_and_steady,
    always_all_in,
    all_in_with_limit,
    all_in_then_quit,
  ]

  let tosses = get_tosses(rounds, odds)
  use current_strategy <- list.map(strategies)
  let strategy_results =
    yielder.scan(
      tosses,
      #(initial_funds, 0, 0),
      fn(last_round_results, current_result) {
        let #(last_round_funds, last_wager_result, round_index) =
          last_round_results
        let current_wager =
          current_strategy.run(last_round_funds, last_wager_result)
        let current_wager = case current_wager > last_round_funds {
          False -> current_wager
          True -> last_round_funds
        }

        let current_wager_result = case current_result {
          False -> -current_wager
          True -> current_wager
        }
        let current_funds =
          last_round_funds + income_per_round + current_wager_result

        #(current_funds, current_wager_result, round_index + 1)
      },
    )
    |> yielder.map(fn(result) {
      let #(funds, _wager_result, index) = result
      #(index, funds)
    })
    |> yielder.to_list
    |> array.from_list
    |> charts_ffi.do_to_data_set
  #(current_strategy.name, current_strategy.color, strategy_results)
}

fn get_tosses(rounds: Int, odds: Int) -> Tosses {
  let tosses =
    random.int(1, 100)
    |> random.to_random_yielder
    |> yielder.map(fn(pull) { pull <= odds })
  yielder.take(tosses, rounds)
}

// Strategies

fn never_bet(_last_round_funds: Int, _last_round_change: Int) -> Int {
  0
}

fn always_same_bet(_last_round_funds: Int, _last_round_change: Int) -> Int {
  config.always_same_bet_wager
}

fn slow_and_steady(_last_round_funds: Int, last_round_change: Int) -> Int {
  case last_round_change {
    change if change < 0 -> -change * 2
    _else -> 1000
  }
}

fn always_all_in(last_round_funds: Int, _: Int) -> Int {
  last_round_funds
}

fn all_in_with_limit(last_round_funds: Int, _: Int, limit: Int) -> Int {
  int.min(last_round_funds, limit)
}

fn all_in_then_quit(last_round_funds: Int, _: Int, limit: Int) -> Int {
  case last_round_funds >= limit {
    False -> last_round_funds
    True -> 0
  }
}
