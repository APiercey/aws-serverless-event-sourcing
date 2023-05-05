# frozen_string_literal: true

require_relative './shopping_cart.rb'
require_relative './shared/dynamo_db_repo.rb'
require_relative './events/builder.rb'

class ShoppingCartRepo < DynamoDBRepo
  aggregate ShoppingCart
  event_builder Events::Builder
end
