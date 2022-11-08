# data "harness_secret_manager" "default" {
#   id = "harnessSecretManager"
# }

resource "harness_platform_secret_text" "github_token" {
  identifier        = "${var.prefix}_helloTokenSecret"
  name              = "hello-github-token"
  value             = var.github_token
  value_type        = "Inline"
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
  //secret_manager_identifier = data.harness_secret_manager.default.id
  secret_manager_identifier = "harnessSecretManager"
}

resource "harness_platform_connector_helm" "tf_bitnami" {
  identifier = "tf_bitnami"
  name = "tf_bitnami"
  url = "https://charts.bitnami.com/bitnami"
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
}

resource "harness_platform_connector_docker" "tf_dockerhub" {
  identifier = "tf_dockerhub"
  name = "tf_dockerhub"
  url = "https://registry.hub.docker.com/v2/"
  type = "DockerHub"
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
}
