require 'pry'
require 'aws-sdk-dynamodb'
require_relative 'core'

dynamo_db_client = EsDynamoTableClient.new(Aws::DynamoDB::Client.new, "scd-es-table")
repo = ShoppingCartRepo.new(dynamo_db_client)

binding.pry
