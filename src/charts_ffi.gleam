import gleam/javascript/array

pub type Chart

pub type ChartData

@external(javascript, "./chart_ffi.mjs", "init_chart")
pub fn do_init_chart(
  element_id: String,
  datasets: array.Array(#(String, String, ChartData)),
) -> Chart

@external(javascript, "./chart_ffi.mjs", "to_data_set")
pub fn do_to_data_set(data: array.Array(#(Int, Int))) -> ChartData

@external(javascript, "./chart_ffi.mjs", "destroy_chart")
pub fn do_destroy_chart(chart: Chart) -> Nil
