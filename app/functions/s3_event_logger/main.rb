# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-s3'

def pluck_kinesis_change_events(event)
  event
    .fetch('Records')
    .map { |source| source.fetch('kinesis', nil) }
    .reject(&:nil?)
    .map { |k| [k.fetch('sequenceNumber'), Base64.decode64(k.fetch('data'))] }
    .reject { |_, event| event.nil? }
end

def handler(event:, context:)
  s3_bucket = Aws::S3::Resource.new.bucket(ENV['s3_bucket_name'])

  pluck_kinesis_change_events(event).each do |event_id, event|
    s3_bucket.put_object(
      body: event,
      key: event_id
    )
  end

  { event: JSON.generate(event), context: JSON.generate(context.inspect) }
end
