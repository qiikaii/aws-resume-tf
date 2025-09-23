provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "region-us-east-1"
}

module "s3_bucket" {
  source = "./modules/s3"
}

module "dynamodb_table" {
  source = "./modules/dynamodb"
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws                  = aws
    aws.region-us-east-1 = aws.region-us-east-1
  }

  dynamodb_id = module.dynamodb_table.dynamodb_id
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  s3_domain_name      = module.s3_bucket.s3_bucket_domain_name
  cloudfront_cert_arn = module.acm.cloudfront_cert_arn
}

module "iam" {
  source       = "./modules/iam"
  lambda_name  = module.lambda.lambda_resumecounter_function_name
  dynamodb_arn = module.dynamodb_table.dynamodb_arn
}

module "lambda" {
  source                       = "./modules/lambda"
  iam_role_lambdaexecution_arn = module.iam.iam_role_lambdaexecution_arn
  dynamodb_name                = module.dynamodb_table.dynamodb_name
}

module "apigw" {
  source                             = "./modules/apigw"
  lambda_resumecounter_invoke_arn    = module.lambda.lambda_resumecounter_invoke_arn
  lambda_resumecounter_function_name = module.lambda.lambda_resumecounter_function_name
  api-gateway-cert_arn               = module.acm.api-gateway-cert_arn
  s3_bucket_id                       = module.s3_bucket.s3_bucket_id
  s3_bucket_arn                      = module.s3_bucket.s3_bucket_arn
  cf_resume_arn                      = module.cloudfront.cf_resume_arn
}

/*
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "test_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames = true
}
*/