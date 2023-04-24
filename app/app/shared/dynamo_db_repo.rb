# frozen_string_literal: true

require 'json'

class DynamoDBRepo
  class DynamoDBTableUndefined < StandardError
    def message
      "DynamoDB table is not defined"
    end
  end

  class AggregateClassUndefined < StandardError
    def message
      "Aggregate class is not defined"
    end
  end

  class EventBuilderModuleUndefined < StandardError
    def message
      "Event builder module is not defined"
    end
  end

  @table_name = nil
  @aggregate_class = nil
  @event_builder_module = nil

  def initialize(dynamodb_client)
    @dynamodb_client = dynamodb_client

    raise DynamoDBTableUndefined if table_name.nil?
    raise AggregateClassUndefined if aggregate_class.nil?
    raise EventBuilderModuleUndefined if event_builder_module.nil?
  end

  def self.table(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name
  end

  def self.aggregate(aggregate_class)
    @aggregate_class = aggregate_class
  end

  def self.aggregate_class
    @aggregate_class
  end

  def self.event_builder(event_builder)
    @event_builder_module = event_builder
  end

  def self.event_builder_module
    @event_builder_module
  end

  def fetch(uuid)
    agg = aggregate_class.new

    record = fetch_aggregate_record(uuid)

    return nil if record.nil?

    agg.version = record.fetch("Version")

    record
      .fetch("Events", [])
      .map { |event| build_event(event) }
      .reject(&:nil?)
      .each { |event| agg.apply(event) }

    if agg.uuid.nil?
      nil
    else
      agg
    end
  end

  def store(agg)
    update_aggregate_record(agg)
    agg.clear_changes

    agg
  end

  private

  def fetch_aggregate_record(uuid)
    @dynamodb_client.get_item({
      table_name: "ShoppingCart",
      key: { Uuid: uuid }
    }).item
  end

  def update_aggregate_record(agg)
    new_version = (agg.version || 0) + 1
    new_events = agg.changes.map { |event| { Name: event.class::NAME, Data: event.to_h, Version: new_version } }

    @dynamodb_client.update_item({
      table_name: table_name,
      key: {
        Uuid: agg.uuid
      },
      update_expression: "SET #el = list_append(if_not_exists(#el, :empty_list), :new_events), #version = :new_version",
      condition_expression: "#version = :new_version",
      expression_attribute_names: {
        "#el" => "Events",
        "#version" => "Version"
      },
      expression_attribute_values: {
        ":empty_list" => [],
        ":new_events" => new_events,
        ":new_version" => new_version
      },
    })
  end

  def build_event(raw_event)
    event_builder_module.build(raw_event.fetch('Name'), raw_event.fetch('Data'))
  end

  def table_name
    self.class.table_name
  end

  def aggregate_class
    self.class.aggregate_class
  end

  def event_builder_module
    self.class.event_builder_module
  end
end
