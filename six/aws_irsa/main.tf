####################
#
# Harness Content Default Module
#
####################

provider "harness" {
  endpoint         = var.harness_platform_url
  account_id       = var.harness_platform_account
  platform_api_key = var.harness_platform_key
}


data "harness_platform_organization" "org" {
  name = var.organization_name
}


data "harness_platform_project" "project" {
  name   = var.project_name
  org_id = data.harness_platform_organization.org.id
}

module "aws" {
  source = "./modules/aws/cloud"
  name = "aws_<+pipeline.variables.connector_name>"
  credentials = {
    type = "irsa"
    role_arn = "<+pipeline.variables.arn>"
    external_id = "<+pipeline.variables.external_id>"
  }

  
  
}
