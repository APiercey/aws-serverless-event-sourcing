variable "lambda" {
  type = object({
    role_name = string
    function_arn = string
    function_name = string
  })
}

variable "event_stream" {
  type = object({
    bucket_name = string
    stream_arn = string
  })
}
