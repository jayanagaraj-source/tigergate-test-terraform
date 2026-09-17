# Insecure messaging: unencrypted SNS topic and SQS queue.
resource "aws_sns_topic" "events" {
  name = "events"
}

resource "aws_sqs_queue" "jobs" {
  name = "jobs"
}
