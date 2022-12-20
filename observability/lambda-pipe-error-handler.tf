resource "aws_lambda_function" "pipe_error_handler" {
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.pipe_error_handler.output_base64sha256
  function_name    = "${local.project_name}-snowpipe-error-handler-to-cloudwatch"
  role             = aws_iam_role.invoke_error_notification_lambda.arn
  handler          = "pipe_error_logging.handler"
  runtime          = "python3.9"
}

resource "aws_lambda_event_source_mapping" "pipe_error_handler" {
  event_source_arn = aws_sqs_queue.error_channel.arn
  function_name    = aws_lambda_function.pipe_error_handler.function_name
  batch_size       = 1
  enabled          = true
}

data "archive_file" "pipe_error_handler" {
  source_dir  = "./lambda/"
  output_path = "./lambda.zip"
  type        = "zip"
}


resource "aws_iam_role" "invoke_error_notification_lambda" {
  name               = "${local.project_name}-snowpipe-error-handler-to-cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.pipe_error_handler.json
}

data "aws_iam_policy_document" "pipe_error_handler" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.invoke_error_notification_lambda.id
  policy_arn = aws_iam_policy.lambda_execution.arn
}

resource "aws_iam_policy" "lambda_execution" {
  name        = "${local.project_name}-lambda-policy"
  description = "${local.project_name}-lambda-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_sqs_queue.error_channel.arn}",
        "${aws_sqs_queue.error_channel_dead_letter_queue.arn}"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:DescribeLogStreams",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:PutMetricData"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
