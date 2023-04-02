require_relative './mt.rb'
require_relative './helpers.rb'


MT.test "Event Persistence" do
  function_names = list_functions.map(&:function_name)

  num_events = count_events
  call_function("open_cart", {})

  sleep 3

  MT.assert("Event is persisted to storage", count_events, :equals, num_events + 1)
end
