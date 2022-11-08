terraform {
  required_providers {
    harness = {
      source = "harness/harness"
      version = "0.7.1"
    }
    aws = {
     source  = "hashicorp/aws"
     version = "~> 4.38.0"
   }
  }
}

provider "aws" {
 region = "us-west-1"
}

#Configure the Harness provider for Next Gen resources
provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = var.harness_account_id
  platform_api_key = var.harness_apikey
}