class EsDynamoTableClient
  def initialize(dynamodb_client, table_name)
    @dynamodb_client = dynamodb_client
    @table_name = table_name
  end

  def fetch_aggregate_events(aggregate_uuid)
    query_options = {
      table_name: @table_name,
      key_condition_expression: "AggregateUuid = :aggregate_uuid",
      expression_attribute_values: {
        ":aggregate_uuid" => aggregate_uuid,
      },
      consistent_read: true
    }

    items = []

    result = @dynamodb_client.query(query_options)

    loop do
      items << result.items

      break unless (last_evaluated_key = result.last_evaluated_key)

      result = @dynamodb_client.query(query_options.merge(exclusive_start_key: last_evaluated_key))
    end

    items.flatten
  end

  def insert_aggregate_events!(events)
    put_operations = events.map do |event|
      {
        put: {
          item: event,
          table_name: @table_name,
          condition_expression: "attribute_not_exists(#v)",
          expression_attribute_names: {
            "#v" => "Version"
          }
        }
      }
    end

    @dynamodb_client.transact_write_items({transact_items: put_operations})

    nil
  end
end
