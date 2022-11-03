terraform {
  required_providers {
    harness = {
      source = "harness/harness"
      version = "0.6.11"
    }
  }
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}

#Configure the Harness provider for Next Gen resources
provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = data.external.env.result["account_id"]
  platform_api_key = data.external.env.result["platform_api_key"]
}

