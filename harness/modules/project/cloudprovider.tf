resource "harness_platform_connector_kubernetes" "example" {
  name = "k8s_connector_${harness_platform_project.example.id}"
  identifier = "k8s_connector_${harness_platform_project.example.id}"
  tags = ["terraform:terraform"]
  inherit_from_delegate {
    delegate_selectors = ["mac"]
  }
  org_id = harness_platform_organization.example.id
  project_id = harness_platform_project.example.id
  description = ""
}
