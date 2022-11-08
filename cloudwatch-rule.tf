resource "aws_cloudwatch_event_rule" "cw_log_group_rention" {
  name        = "newlog-group-retention-period"
  description = "All new logs groups should have a standard retention period."

  event_pattern = <<EOF
    {
        "source": ["aws.logs"],
        "detail-type": ["AWS API Call via CloudTrail"],
        "detail": {
            "eventSource": ["logs.amazonaws.com"],
            "eventName": ["CreateLogGroup"]
        }
    }
EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.cw_log_group_rention.name
  target_id = "SendToLambdaFunction"
  arn       = aws_lambda_function.cw_lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.cw_lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.cw_log_group_rention.arn
}