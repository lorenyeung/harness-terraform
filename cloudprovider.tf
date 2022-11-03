resource "harness_platform_connector_kubernetes" "demo" {
  name = "${var.prefix}-kubernetes"
  identifier = "hello"
  tags = ["terraform:terraform"]
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
