

# resource "aws_cloudwatch_log_group" "lambda_function" {
#   name              = "/aws/lambda/cw_lambda_function"
#   retention_in_days = 7 
# }


data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = "./lambda_function_payload"
    output_path = "lambda.zip"
}

resource "aws_lambda_function" "cw_lambda_function" {
  filename = "lambda.zip"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name = "cw_lambda_function"
  role = aws_iam_role.cw_lambda_role.arn
  handler = "index.handler"
  runtime = "nodejs14.x"
}