variable "github_username" {
  description = "The github username used for the git connector."
  default = "hello"
}

variable "github_token" {
  description = "The github token for used for the git connector."
}

variable "harness_account_id" {
  description = "The Harness account ID"
}

variable "harness_apikey" {
  description = "The Harness account API key. Will require account level privileges."
}


variable "prefix" {
  description = "A prefix to use to ensure account level settings are unique (i.e. cloud providers, secrets, connectors, etc.)."
  default = "test"
}

variable "repository_url" {
  description = "The url of the repository to be cloned."
  default = "https://github.com/harness-io/terraform-demo"
}

variable "repository_branch" {
  description = "The branch of the repository to use for the git connector."
  default = "main"
}

variable "org" {
  description = "Harness org id to be created"
  default = ["org1","org2"]
}

variable "project" {
  description = "Harness project id to be created"
  default = ["terra_project","terra_project2"]
}

variable "pipeline_name" {
}

variable "s3_bucket_name" {
}
