# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodb'
require 'ostruct'
require_relative '../../app/core'
require_relative '../../app/domain_services/add_item'

def handler(event:, context:)
  dynamo_db_client = EsDynamoTableClient.new(Aws::DynamoDB::Client.new, "scd-es-table")
  shopping_cart_repo = ShoppingCartRepo.new(dynamo_db_client)

  shopping_cart = DomainServices::AddItem
    .new(shopping_cart_repo)
    .call(event["ShoppingCartID"], event["ItemName"])

  { event: shopping_cart._to_h, context: JSON.generate(context.inspect) }
end
