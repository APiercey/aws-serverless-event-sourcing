require_relative './cart_opened.rb'
require_relative './item_added.rb'

module Events
  class Builder
    def build(name, data)
      case name
      when "CartOpened"
        Events::CartOpened.new(data.fetch("shopping_cart_uuid"))
      when "ItemAdded"
        Events::ItemAdded.new(data.fetch("shopping_cart_uuid"), data.fetch("item_name"))
      else
        nil
      end
    end
  end
end
