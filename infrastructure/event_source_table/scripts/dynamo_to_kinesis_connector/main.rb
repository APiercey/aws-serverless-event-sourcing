# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-dynamodbstreams'
require 'aws-sdk-kinesis'
require 'securerandom'

def pluck_new_events(event)
  events_matrix = Aws::DynamoDBStreams::AttributeTranslator
    .from_event(event)
    .map do |record|
      new_image_events = record.dynamodb.new_image.fetch("Events")
      old_image_events = (record.dynamodb.old_image || {}).fetch("Events", [])

      new_events = new_image_events[old_image_events.count..]
    end

  events_matrix.flatten
end

def handler(event:, context:)
  kinesis_client = Aws::Kinesis::Client.new

  event_matrix = pluck_new_events(event)

  event_matrix.each do |event|
    kinesis_client.put_record(
      stream_name: ENV['kinesis_event_stream'],
      data: JSON.generate(event),
      partition_key: "all-events"
    )
  end

  { event: JSON.generate(event_matrix), context: JSON.generate(context.inspect) }
end
