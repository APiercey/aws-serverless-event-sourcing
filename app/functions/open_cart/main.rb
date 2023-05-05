# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodb'
require_relative '../../app/core'
require_relative '../../app/domain_services/open_cart'

def handler(event:, context:)
  dynamo_db_client = EsDynamoTableClient.new(Aws::DynamoDB::Client.new, "scd-es-table")
  shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client)

  shopping_cart = DomainServices::OpenCart
    .new(shopping_cart_repo)
    .call

  { event: shopping_cart.to_h, context: JSON.generate(context.inspect) }
end
