# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodb'
require 'ostruct'
require_relative '../../app/core'
require_relative '../../app/domain_services/close_cart'

def handler(event:, context:)
  dynamo_db_client = Aws::DynamoDB::Client.new
  event_builder = Events::Builder.new
  shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client, event_builder, "ShoppingCarts", ShoppingCart)

  shopping_cart = DomainServices::CloseCart
    .new(shopping_cart_repo)
    .call(event["ShoppingCartID"])

  { event: shopping_cart.to_h, context: JSON.generate(context.inspect) }
end
