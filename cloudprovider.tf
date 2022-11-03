resource "harness_platform_connector_kubernetes" "demo" {
  name = "${var.prefix}-kubernetes"
  identifier = "hello"
  tags = ["terraform:terraform"]
  inherit_from_delegate {
    delegate_selectors = ["mac"]
  }
}
