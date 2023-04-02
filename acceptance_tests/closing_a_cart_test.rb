require_relative './mt.rb'
require_relative './helpers.rb'


MT.test "Closing a Cart" do
  cart_uuid = call_function("open_cart", {}).dig("event", "uuid")

  uuid = call_function("close_cart", {"ShoppingCartID" => cart_uuid}).dig("event", "uuid")

  MT.assert("close_cart closes the cart", uuid, :is_nil)

  uuid = call_function("close_cart", {"ShoppingCartID" => cart_uuid}).dig("event", "uuid")

  MT.assert("get_cart is nil", uuid, :is_nil)
end
