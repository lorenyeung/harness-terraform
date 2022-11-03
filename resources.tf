
resource "harness_platform_organization" "example" {
  identifier = var.org[count.index]
  name       = var.org[count.index]
  count = length(var.org)
}

resource "harness_platform_project" "example" {
  identifier = var.project[count.index]
  name       = var.project[count.index]
  org_id     = var.org[count.index]
  depends_on = [
    harness_platform_organization.example
  ]
  count = length(var.project)
}

resource "harness_platform_service" "example" {
  identifier  = "cd_example_service_${var.project[count.index]}"
  name        = "cd_example_service"
  description = "test"
  org_id      = var.org[count.index]
  project_id  = var.project[count.index]
  depends_on = [
    harness_platform_project.example
  ]
    count = length(var.project)
}
