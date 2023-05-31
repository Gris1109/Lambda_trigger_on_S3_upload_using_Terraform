# output of lambda arn
output "lambda_arn" {
  description = "lambda function arn"
  value = aws_lambda_function.terra_lambda.arn
}