# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodb'
require_relative '../../app/shopping_cart_repo'
require_relative '../../app/domain_services/add_item'

def handler(event:, context:)
  dynamo_db_client = Aws::DynamoDB::Client.new
  shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client)

  shopping_cart = DomainServices::AddItem
    .new(shopping_cart_repo)
    .call(event["ShoppingCartID"], event["ItemName"])

  { event: shopping_cart.inspect, context: JSON.generate(context.inspect) }
end
