data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_role" "role_lambdaexecution" {
    name                    = "visitorCounter_Lambda_Role_TF"
    description             = "IAM Role for lambda created by Terraform"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action                  = "sts:AssumeRole"
            Effect                  = "Allow"
            Principal               = {
                Service             = "lambda.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy" "policy_lambdaexecution" {
    name                    = "LambdaExecutionPolicy-TF"
    role                    = aws_iam_role.role_lambdaexecution.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action                  = "logs:CreateLogGroup"
            Effect                  = "Allow"
            Resource                = "arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:*"
        },
        {
            Action                  = ["logs:CreateLogStream",
                                        "logs:PutLogEvents"]
            Effect                  = "Allow"
            Resource                = "arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
        },
        {
            Action                  = ["dynamodb:GetItem",
                                        "dynamodb:UpdateItem",
                                        "dynamodb:PutItem",
                                        "dynamodb:Scan"]
            Effect                  = "Allow"
            Resource                = var.dynamodb_arn
        }]
    })
}