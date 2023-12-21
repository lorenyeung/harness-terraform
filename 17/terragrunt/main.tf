terraform {
  required_providers {
    harness = {
      source = "harness/harness"
      version = "0.29.4"
    }
  }
}

provider "harness" {
  endpoint         = var.harness_platform_url
  account_id       = var.harness_platform_account
  platform_api_key = var.harness_platform_key
}
