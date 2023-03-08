# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodb'
require 'ostruct'
require_relative '../../app/core'
require_relative '../../app/domain_services/add_item'

# class FakeClient
#   def get_item(_query)
#     OpenStruct.new(
#       item: { "Events" => [{"Name" => "CartOpened", "Data" => { "shopping_cart_uuid" => "test-uuid" }}] }
#     )
#   end

#   def update_item(_query)
#     true
#   end
# end

# dynamo_db_client = FakeClient.new
#   event_builder = Events::Builder.new
#   shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client, event_builder, "ShoppingCart", ShoppingCart)
#   shopping_cart_repo.fetch("asd")

#   shopping_cart = DomainServices::AddItem
#     .new(shopping_cart_repo)
#     .call(event["ShoppingCartID"], event["ItemName"])

def handler(event:, context:)
  dynamo_db_client = Aws::DynamoDB::Client.new
  shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client)

  shopping_cart = DomainServices::AddItem
    .new(shopping_cart_repo)
    .call(event["ShoppingCartID"], event["ItemName"])

  { event: shopping_cart.inspect, context: JSON.generate(context.inspect) }
end
