require_relative './mt.rb'
require_relative './helpers.rb'


MT.test "Open Cart" do
  function_names = list_functions.map(&:function_name)

  MT.assert("open_cart exists", function_names, :contains, "open_cart")

  uuid = call_function("open_cart", {}).dig("event", "uuid")

  MT.assert("get_cart exists", function_names, :contains, "get_cart")

  expected_uuid = call_function("open_cart", {}).dig("event", "uuid")

  uuid = call_function("get_cart", {"ShoppingCartID" => expected_uuid}).dig("event", "uuid")

  MT.assert("get_cart provides correct Cart UUID", uuid, :equals, expected_uuid)
end
