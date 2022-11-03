resource "harness_platform_connector_kubernetes" "demo" {
  name = "k8s_connector_${var.project[count.index]}"
  identifier = "k8s_connector_${var.project[count.index]}"
  tags = ["terraform:terraform",var.org[count.index]]
  inherit_from_delegate {
    delegate_selectors = ["mac"]
  }
  org_id = var.org[count.index]
  project_id = var.project[count.index]
  description = ""
  count = length(var.project)
  depends_on = [
    harness_platform_project.example
  ]
}
