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

module "organization" {
    source = "./modules/organization"
    #other-input-variable = "..."
}

module "pipelines" {
    source = "./modules/pipelines"
    #other-input-variable = "..."
}

module "project" {
    source = "./modules/project"
    #other-input-variable = "..."
}

module "s3" {
    source = "./modules/s3"
    #other-input-variable = "..."
}

data "harness_platform_template" "example2" {
  identifier = "datadog_private_locations_managed"
  version    = "v1"
  org_id     = "default"
  project_id = "technical_exercise"
}
