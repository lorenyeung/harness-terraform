
resource "harness_platform_organization" "example" {
  identifier = var.org[count.index]
  name       = var.org[count.index]
  count      = length(var.org)
}

resource "harness_platform_project" "example" {
  org_id     = harness_platform_organization.example[count.index].id
  identifier = var.project[count.index]
  name       = var.project[count.index]
  count      = length(var.project)
}

resource "harness_platform_service" "example" {
  identifier  = "cd_example_service_${harness_platform_project.example[count.index].id}"
  name        = "cd_example_service_${harness_platform_project.example[count.index].id}"
  description = "test"
  org_id      = harness_platform_organization.example[count.index].id
  project_id  = harness_platform_project.example[count.index].id
  count       = length(var.project)
}
