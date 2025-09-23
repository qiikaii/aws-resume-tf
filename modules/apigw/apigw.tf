data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_apigatewayv2_api" "apigw_http_v2_visitorcount" {
    name                    = "visitor-count-api"
    protocol_type           = "HTTP"

    disable_execute_api_endpoint = true
    
    cors_configuration {
        allow_credentials           = true
        allow_headers               = ["content-type",
                                        "cookie"]
        allow_methods               = ["GET",
                                        "OPTIONS",
                                        "PUT"]
        allow_origins               = ["https://api.resume.sidpanic.io",
                                        "https://resume.sidpanic.io"]
    }   
}

resource "aws_apigatewayv2_integration" "apigw_integration_lambdaintegration" {
    api_id                  = aws_apigatewayv2_api.apigw_http_v2_visitorcount.id
    integration_type        = "AWS_PROXY"

    integration_uri         = var.lambda_resumecounter_invoke_arn
    description             = "Integration with Lambda Resume"
    integration_method      = "POST"
    payload_format_version = "2.0"

    request_parameters = {
        "append:header.Cookie"          = "$request.header.Cookie"
    }

    response_parameters {
        status_code = 200
        mappings = {
            "append:header.Set-Cookie"  = "$integration.response.header.Set-Cookie" 
        }
    }

}

resource "aws_lambda_permission" "allow_apigw_invoke" {
    statement_id                    = "AllowAPIGatewayInvoke-TF"
    action                          = "lambda:InvokeFunction"
    function_name                   = var.lambda_resumecounter_function_name
    principal                       = "apigateway.amazonaws.com"
    source_arn                      = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.apigw_http_v2_visitorcount.id}/*/*/*"
    ## source_arn                      = "${aws_apigatewayv2_api.apigw_http_v2_visitorcount.arn}/*/*"
}

resource "aws_apigatewayv2_route" "apigw_http_v2_visitorcount_route" {
    api_id                  = aws_apigatewayv2_api.apigw_http_v2_visitorcount.id
    route_key               = "GET /visitor-count"
    target                  = "integrations/${aws_apigatewayv2_integration.apigw_integration_lambdaintegration.id}"
}

resource "aws_apigatewayv2_deployment" "apigw_http_v2_visitorcount_deployment" {
    api_id                  = aws_apigatewayv2_api.apigw_http_v2_visitorcount.id

    depends_on = [ 
        aws_apigatewayv2_integration.apigw_integration_lambdaintegration,
        aws_apigatewayv2_route.apigw_http_v2_visitorcount_route
     ]
}

resource "aws_apigatewayv2_stage" "PROD" {
    api_id                  = aws_apigatewayv2_api.apigw_http_v2_visitorcount.id
    name                    = "PROD"
    # deployment_id           = aws_apigatewayv2_deployment.apigw_http_v2_visitorcount_deployment.id
    auto_deploy             = true
}

resource "aws_apigatewayv2_domain_name" "apigw_customdns_api_resume" {
    domain_name             = "api.resume.sidpanic.io"

    domain_name_configuration {
        certificate_arn     = var.api-gateway-cert_arn
        endpoint_type       = "REGIONAL"
        security_policy    = "TLS_1_2"
    }
}

resource "aws_apigatewayv2_api_mapping" "apigw_customdns_api_resume_path_mapping" {
  api_id                    = aws_apigatewayv2_api.apigw_http_v2_visitorcount.id
  domain_name               = aws_apigatewayv2_domain_name.apigw_customdns_api_resume.id
  stage                     = aws_apigatewayv2_stage.PROD.id
}

# Allow public read index.html
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = {
            Service     = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = ["${var.s3_bucket_arn}/index.html",
                    "${var.s3_bucket_arn}/displaypic.jpg"
            ]
        Condition = {
            StringEquals    = {
                "AWS:SourceArn" = var.cf_resume_arn
            }
        }
      }
    ]
  })
}