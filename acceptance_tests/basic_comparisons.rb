require_relative './framework.rb'
require_relative './helpers.rb'

# MT.test "Open Cart" do
#   function_names = list_functions.map(&:function_name)

#   MT.assert("open_cart exists", function_names, :contains, "open_carts")

#   MT.assert("get_cart exists", function_names, :contains, "get_cart")

#   MT.assert("add_item exists", function_names, :contains, "add_item")

#   result = call_function("open_cart", {})

#   MT.assert("open_cart provides a UUID", result["event"]["uuid"], :is_a, String)
# end

# MT.test "Get Cart" do
#   function_names = list_functions.map(&:function_name)

#   MT.assert("open_cart exists", function_names, :contains, "open_carts")

#   MT.assert("get_cart exists", function_names, :contains, "get_cart")

#   MT.assert("add_item exists", function_names, :contains, "add_item")

#   result = call_function("open_cart", {})

#   MT.assert("open_cart provides a UUID", result["event"]["uuid"], :is_a, String)
# end

MT.test "Basic comparisons" do
  MT.assert("Comparing values", 1, :equals, 1)
  MT.assert("Array contents", [1, 2, 3], :contains, 3)
  MT.assert("Class types", "Hello world", :is_a, String)
  MT.assert("true is truthy", true, :is_truthy)
  MT.assert("objects are truthy", "Technically an object", :is_truthy)
  MT.assert("false is falsey", false, :is_falsey)
  MT.assert("nil is falsey", false, :is_falsey)
  MT.assert("nil is nil", nil, :is_nil)
  MT.assert("Strings can be matched", "Foo bar", :matches, /Foo/)
end

class Animal ; end
class Dog < Animal
  def bark
    "Woof! woof!"
  end
end

MT.test "Dog" do
  dog = Dog.new

  MT.assert("it is an Animal", dog, :is_a, Animal)
  MT.assert("it woofs when it barks", dog.bark, :equals, "Woof! woof!")
end
