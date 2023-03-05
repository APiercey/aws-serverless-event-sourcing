# frozen_string_literal: true

require 'json'
require 'base64'
require 'aws-sdk-s3'

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['s3_bucket_name'])
# TEST_DATA = {"Records"=>[{"kinesis"=>{"kinesisSchemaVersion"=>"1.0", "partitionKey"=>"4CA86E7CD2E587D82DCDB714268D03A0", "sequenceNumber"=>"49638563193255985256474339372948583918029034905241911298", "data"=>"eyJhd3NSZWdpb24iOiJ1cy1lYXN0LTEiLCJldmVudElEIjoiZmE4M2VlYTQtY2Y2Zi00ZmYzLTgzZWQtMmM2NTdkZGU4NDU1IiwiZXZlbnROYW1lIjoiTU9ESUZZIiwidXNlcklkZW50aXR5IjpudWxsLCJyZWNvcmRGb3JtYXQiOiJhcHBsaWNhdGlvbi9qc29uIiwidGFibGVOYW1lIjoiU2hvcHBpbmdDYXJ0cyIsImR5bmFtb2RiIjp7IkFwcHJveGltYXRlQ3JlYXRpb25EYXRlVGltZSI6MTY3NzkzNjY2NjkzNiwiS2V5cyI6eyJVdWlkIjp7IlMiOiIxMTEifX0sIk5ld0ltYWdlIjp7IkV2ZW50cyI6eyJMIjpbeyJTIjoie1wiZm9vXCI6IFwiYmFyXCJ9In0seyJTIjoie1wiZm9vXCI6IFwiYmFyMlwifSJ9LHsiUyI6IntcImZvb1wiOiBcImJhcjNcIn0ifSx7IlMiOiJ7XCJmb29cIjogXCJiYXI0XCJ9In0seyJTIjoie1wiZm9vXCI6IFwiYmFyNVwifSJ9XX0sIlV1aWQiOnsiUyI6IjExMSJ9fSwiT2xkSW1hZ2UiOnsiRXZlbnRzIjp7IkwiOlt7IlMiOiJ7XCJmb29cIjogXCJiYXJcIn0ifSx7IlMiOiJ7XCJmb29cIjogXCJiYXIyXCJ9In0seyJTIjoie1wiZm9vXCI6IFwiYmFyM1wifSJ9LHsiUyI6IntcImZvb1wiOiBcImJhcjRcIn0ifV19LCJVdWlkIjp7IlMiOiIxMTEifX0sIlNpemVCeXRlcyI6MTgxfSwiZXZlbnRTb3VyY2UiOiJhd3M6ZHluYW1vZGIifQ==", "approximateArrivalTimestamp"=>1677936667.257}, "eventSource"=>"aws:kinesis", "eventVersion"=>"1.0", "eventID"=>"shardId-000000000000:49638563193255985256474339372948583918029034905241911298", "eventName"=>"aws:kinesis:record", "invokeIdentityArn"=>"arn:aws:iam::311476293586:role/iam_for_lambda", "awsRegion"=>"us-east-1", "eventSourceARN"=>"arn:aws:kinesis:us-east-1:311476293586:stream/event_stream"}]}

def pluck_kinesis_change_events(event)
  event
    .fetch('Records')
    .map { |source| source.fetch('kinesis', nil) }
    .reject(&:nil?)
    .map { |k| [k.fetch('sequenceNumber'), event_data(k.fetch('data'))] }
    .reject { |_, event| event.nil? }
end

def event_data(data)
  decoded_data = Base64.decode64(data)
  change_capture = JSON.parse(decoded_data).fetch('dynamodb')

  return nil unless event_change?(change_capture)

  change_capture
    .dig('NewImage', 'Events', 'L')
    .last
    .fetch('S')
end

def event_change?(change_capture)
  old_events = change_capture.dig('OldImage', 'Events', 'L')
  new_events = change_capture.dig('NewImage', 'Events', 'L')

  old_events != new_events
end

def handler(event:, context:)
  pluck_kinesis_change_events(event).each do |event_id, event|
    S3_BUCKET.put_object(
      body: event,
      key: event_id
    )
  end

  { event: JSON.generate(event), context: JSON.generate(context.inspect) }
end
