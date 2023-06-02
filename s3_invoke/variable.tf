#Create Variables
variable "function_name" {
  default = "lambda_fun"
  description = "The AWS region in which the resources will be created."
  type        = string
}

variable "Lruntime" {
  default = "python3.8"
}

variable "Ltimeout" {
  default = "900"
}

variable "lambda_role_name" {
  default = "lambda_iam_role"
}

variable "lambda_iam_policy_name" {
  default = "lambda_iam_policy"
}

variable "bucket_name" {
  default = "s3invokebucket784199"
}

variable "region" {
  default = "us-east-1"
}