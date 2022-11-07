resource "harness_platform_connector_kubernetes" "example" {
  name = "k8s_connector_${harness_platform_project.example[count.index].id}"
  identifier = "k8s_connector_${harness_platform_project.example[count.index].id}"
  tags = ["terraform:terraform"]
  inherit_from_delegate {
    delegate_selectors = ["mac","amazon"]
  }
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
  description = ""
  count = length(var.project)
}
