terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = var.harness_account_id
  platform_api_key = var.harness_apikey
}

provider "aws" {
  region = "us-west-1"
}