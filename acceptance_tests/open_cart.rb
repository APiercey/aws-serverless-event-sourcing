require_relative './mt.rb'
require_relative './helpers.rb'

MT.test "Open Cart" do
  function_names = list_functions.map(&:function_name)

  MT.assert("open_cart exists", function_names, :contains, "open_carts")

  uuid = call_function("open_cart", {}).dig("event", "uuid")

  MT.assert("open_cart provides a UUID", uuid, :is_a, String)
end

MT.test "Get Cart" do
  function_names = list_functions.map(&:function_name)

  MT.assert("get_cart exists", function_names, :contains, "get_cart")

  expected_uuid = call_function("open_cart", {}).dig("event", "uuid")
  uuid = call_function("get_cart", {}).dig("event", "uuid")

  MT.assert("open_cart provides a UUID", uuid, :equals, expected_uuid)
end
