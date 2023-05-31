# aws_iam_role                       
resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_role_name
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

# aws_iam_role_policy
resource "aws_iam_group_policy" "role_policy" {
  name = var.lambda_iam_policy
  policy = file("${path.module}/policy.json")
  role = aws_iam_role.lambda_iam.id
}

# aws_lambda_function
resource "aws_lambda_function" "terra_lambda" {
  function_name =var.lambda_fun
  role = aws_iam_role.lambda_iam.arn
  handler = "src/lambda_function.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = "../src.zip"  # Path to your ZIP file
  source_code_hash = filebase64sha256("../src.zip")
}

# aws_s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl = "private"
}

# aws_s3_bucket_notification
resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = aws_s3_bucket.bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.terra_lambda.arn
    events = [ "s3:ObjectCreated:*", "s3:ObjectRemoved:*" ]
  }
}

# aws_lambda_permission
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terra_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}
