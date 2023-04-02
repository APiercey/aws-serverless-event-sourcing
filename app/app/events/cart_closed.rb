# frozen_string_literal: true

module Events
  class CartClosed
    NAME = "CartClosed"
    attr_reader :shopping_cart_uuid

    def initialize(shopping_cart_uuid)
      @shopping_cart_uuid = shopping_cart_uuid
    end

    def to_h
      { shopping_cart_uuid: @shopping_cart_uuid }
    end
  end
end
