# aws_iam_role                       
resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_role_name
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

# aws_iam_role_policy
resource "aws_iam_role_policy" "role_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy.json")
  role = aws_iam_role.lambda_iam.id
}

# archive src folder with python code
data "archive_file" "zip_python_code" {
  type = "zip"
  source_dir = "../src/"     # archive the content of the source folder
  output_path = "../src.zip"  # output zip file to root path
}

# aws_lambda_function
resource "aws_lambda_function" "terra_lambda" {
  function_name =var.function_name
  role = aws_iam_role.lambda_iam.arn
  handler = "lambda_function.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.zip_python_code.output_path # Path to your ZIP file
  source_code_hash = filebase64sha256(data.archive_file.zip_python_code.output_path)
}

# aws_s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_controls]

  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
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
