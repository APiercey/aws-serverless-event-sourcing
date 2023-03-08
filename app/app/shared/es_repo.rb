# frozen_string_literal: true

require 'json'

class EsRepo
  def initialize(client, event_builder, table_name, aggregate_class)
    @client = client
    @event_builder = event_builder
    @table_name = table_name
    @aggregate_class = aggregate_class
  end

  def fetch(uuid)
    agg = @aggregate_class.new

    record = fetch_aggregate_record(uuid)

    return nil if record.nil?

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
    @client.get_item({
      table_name: @table_name,
      key: { Uuid: uuid }
    }).item
  end

  def update_aggregate_record(agg)
    new_events = agg.changes.map { |event| { Name: event.class::NAME, Data: event.to_h } }

    @client.update_item({
      table_name: @table_name,
      key: {
        Uuid: agg.uuid
      },
      update_expression: "SET #el = list_append(if_not_exists(#el, :empty_list), :new_events)",
      expression_attribute_names: {
        "#el" => "Events",
      },
      expression_attribute_values: {
        ":empty_list" => [],
        ":new_events" => new_events
      },
    })
  end

  def build_event(raw_event)
    @event_builder.build(raw_event.fetch('Name'), raw_event.fetch('Data'))
  end
end
