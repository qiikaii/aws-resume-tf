resource "aws_dynamodb_table" "resume-visitors-sessions" {
    name            = var.dynamodb_name
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "sessionID" # partition key

    attribute {
      name          = "sessionID"
      type          = "S"
    }
    
    /* // Not required as it requires indexing, in this case is not relevant
    attribute {
      name          = "ipAddress"
      type          = "S"
    }

    attribute {
      name          = "userAgent"
      type          = "S"
    }

    attribute {
      name          = "visitTime"
      type          = "S"
    }

    attribute {
      name          = "ttl"
      type          = "N"
    } */

    ttl {
        attribute_name  = "ttl"
        enabled         = "true"
    }

    tags = {
      name              = "${var.dynamodb_name}-nametag"
    }
}

