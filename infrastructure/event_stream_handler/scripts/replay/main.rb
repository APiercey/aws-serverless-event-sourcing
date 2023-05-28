require 'aws-sdk-s3'
require 'aws-sdk-sqs'

def handler(event:, context:)
  s3_bucket = Aws::S3::Resource.new.bucket(ENV["event_storage_bucket_name"])
  sqs_queue = Aws::SQS::Queue.new(url: ENV["replay_queue_url"])

  s3_bucket.objects.each do |object|
    sqs_queue.send_message({
      message_body: object.key,
      message_group_id: "replay",
      message_deduplication_id: object.key
    })
  end
end
