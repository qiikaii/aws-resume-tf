data "archive_file" "lambda_function_zip" {
    type                            = "zip"
    source_file                     = "./files/terraform_resume_lambda_function.py"
    output_path                     = "./files/terraform_resume_lambda_function.zip"

}

resource "aws_lambda_function" "lambda_resumecounter" {
    function_name                   = "resumeVisitorCounter-TF"
    handler                         = "terraform_resume_lambda_function.lambda_handler"
    filename                        = data.archive_file.lambda_function_zip.output_path
    role                            = var.iam_role_lambdaexecution_arn
    runtime                         = "python3.13"
    source_code_hash                = data.archive_file.lambda_function_zip.output_base64sha256

    environment {
      variables = {
        CONNECTIONS_SESSION = var.dynamodb_name
      }
    }
}