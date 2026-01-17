# The Dead Letter Queue
resource "aws_sqs_queue" "lambda_dlq" {
  name                      = "${var.project_name}-lambda-dlq"
  message_retention_seconds = 1209600 # 14 days
  receive_wait_time_seconds = 20      # Enable long polling (Free Tier friendly)
}

# The IAM Policy allowing Lambda to send messages to the DLQ
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name = "LambdaSQSPolicy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sqs:SendMessage"
        Effect   = "Allow"
        Resource = aws_sqs_queue.lambda_dlq.arn
      }
    ]
  })
}
