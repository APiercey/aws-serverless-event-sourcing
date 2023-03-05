# frozen_string_literal: true

module Events
  class ItemAdded
    NAME = "ItemAdded"
    attr_reader :name, :shopping_cart_uuid, :item_name

    def initialize(shopping_cart_uuid, item_name)
      @shopping_cart_uuid = shopping_cart_uuid
      @item_name = item_name
    end

    def to_h
      {
        shopping_cart_uuid: @shopping_cart_uuid,
        item_name: @item_name
      }
    end
  end
end
