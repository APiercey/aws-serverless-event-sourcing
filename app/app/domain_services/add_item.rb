# frozen_string_literal: true

require_relative '../shopping_cart'
require 'securerandom'

module DomainServices
  class AddItem
    def initialize(shopping_cart_repo)
      @shopping_cart_repo = shopping_cart_repo
    end

    def call(shopping_cart_uuid, item_name)
      shopping_cart = @shopping_cart_repo.fetch(shopping_cart_uuid)
      shopping_cart.add_item(item_name)

      @shopping_cart_repo.store(shopping_cart)

      shopping_cart
    end
  end
end
