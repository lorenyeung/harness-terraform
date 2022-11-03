# data "harness_secret_manager" "default" {
#   default = true
# }

resource "harness_platform_secret_text" "github_token" {
  identifier        = "${var.prefix}_helloTokenSecret"
  name              = "hello-github-token"
  value             = var.github_token
  value_type        = "Inline"
  //secret_manager_identifier = data.harness_secret_manager.default.id
  secret_manager_identifier = "harnessSecretManager"

  # usage_scope {
  #   environment_filter_type = "NON_PRODUCTION_ENVIRONMENTS"
  # }

  # usage_scope {
  #   environment_filter_type = "PRODUCTION_ENVIRONMENTS"
  # }
}
