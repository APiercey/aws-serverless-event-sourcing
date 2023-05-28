resource "aws_sqs_queue" "replay_queue" {
  name       = "${var.lambda.function_name}-replay.fifo"
  fifo_queue = true
}
