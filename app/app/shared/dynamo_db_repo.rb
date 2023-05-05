# frozen_string_literal: true

require 'json'
require 'securerandom'

class DynamoDBRepo
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

  @aggregate_class = nil
  @event_builder_module = nil

  def initialize(dynamodb_client)
    @dynamodb_client = dynamodb_client

    raise AggregateClassUndefined if aggregate_class.nil?
    raise EventBuilderModuleUndefined if event_builder_module.nil?
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

    events = @dynamodb_client.fetch_aggregate_events(uuid)

    return nil if events.empty?

    agg.version = events.last.fetch("Version").to_i

    events
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
    new_version = agg.version

    new_events = agg.changes.map do |event|
      new_version = new_version + 1

      {
        EventUuid: SecureRandom.uuid,
        AggregateUuid: agg.uuid,
        Name: event.class::NAME,
        Data: event.to_h,
        Version: new_version
      }
    end

    @dynamodb_client.insert_aggregate_events!(new_events)

    agg.clear_changes
    agg.version = new_version
    agg
  end

  private

  def build_event(raw_event)
    event_builder_module.build(raw_event.fetch('Name'), raw_event.fetch('Data'))
  end

  def aggregate_class
    self.class.aggregate_class
  end

  def event_builder_module
    self.class.event_builder_module
  end
end
