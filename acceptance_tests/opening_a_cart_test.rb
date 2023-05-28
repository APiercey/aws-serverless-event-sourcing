require_relative './mt.rb'
require_relative './helpers.rb'

require 'pry'

MT.test "Open Cart" do

  result = call_function("open_cart", {})
  cart_uuid = result.dig("event", "uuid")

  puts result.inspect

  MT.assert("open_cart provides a cart UUID", cart_uuid, :is_a, String)

  uuid = call_function("get_cart", {"ShoppingCartID" => cart_uuid}).dig("event", "uuid")

  MT.assert("get_cart provides correct Cart UUID", uuid, :equals, cart_uuid)
end
