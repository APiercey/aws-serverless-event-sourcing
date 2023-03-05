# frozen_string_literal: true

require_relative '../shopping_cart'
require 'securerandom'

module DomainServices
  class OpenCart
    def initialize(shopping_cart_repo)
      @shopping_cart_repo = shopping_cart_repo
    end

    def call
      shopping_cart = ShoppingCart.new(SecureRandom.uuid)
      @shopping_cart_repo.store(shopping_cart)
      shopping_cart
    end
  end
end
