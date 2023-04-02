# frozen_string_literal: true

require 'json'
require 'aws-sdk-s3'
require 'base64'

def pluck_events(event)
  s3_bucket = Aws::S3::Resource.new.bucket(ENV["event_storage_bucket_name"])

  event
    .fetch("Records", [])
    .map do |record|
      case record["eventSource"]
      when "aws:kinesis"
        Base64.decode64(record.dig("kinesis", "data"))
      when "aws:sqs"
        s3_bucket.object(record.dig("body")).get.body.read
      end
    end
end

def handler(event:, context:)
  pluck_events(event).each { |e| puts JSON.parse(e) }

  { event: JSON.generate(event), context: JSON.generate(context.inspect) }
end
