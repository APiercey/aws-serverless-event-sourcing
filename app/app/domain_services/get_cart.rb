# frozen_string_literal: true

require_relative '../shopping_cart'
require 'securerandom'

module DomainServices
  class GetCart
    def initialize(shopping_cart_repo)
      @shopping_cart_repo = shopping_cart_repo
    end

    def call(shopping_cart_uuid)
      @shopping_cart_repo.fetch(shopping_cart_uuid)
    end
  end
end
