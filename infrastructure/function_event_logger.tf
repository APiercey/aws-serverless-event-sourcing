###
#
# Function
#
###
#module "event_logger" {
#  source = "./lambda"

#  source_dir = "../app"
#  name       = "event-logger"
#  runtime    = "ruby2.7"
#  handler    = "functions/event_logger/main.handler"

#  variables = {
#    event_storage_bucket_name = module.all-event-stream.bucket_name
#  }
#}

####
##
## Triggers
##
####

#TODO : Fix this event handler
#module "event_logger_event_handler" {
#  source       = "./event_stream_handler"
#  lambda       = module.event_logger
#  event_stream = module.all-event-stream
#}

###
#
# IAM Permissions
#
###

