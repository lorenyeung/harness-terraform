resource "harness_platform_usergroup" "project_admin" {
  org_id                    = var.org[count.index]
  project_id                = var.project[count.index]  
  identifier = "${var.project[count.index]}_admin"
  name        = "${var.project[count.index]}_admin"
  description = "Administrators of the ${var.project[count.index]} project."  
  count = length(var.project)
}

resource "harness_platform_role_assignments" "example" {
  identifier                = "${var.project[count.index]}_admin_role_assign"
  org_id                    = var.org[count.index]
  project_id                = var.project[count.index]
  resource_group_identifier = "_all_account_level_resources"
  role_identifier           = "_account_viewer"
  principal {
    identifier = "${var.project[count.index]}_admin"
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
  count = length(var.project)
}


resource "harness_platform_usergroup" "project_developer" {
  org_id                    = var.org[count.index]
  project_id                = var.project[count.index]  
  identifier = "${var.project[count.index]}_dev"
  name        = "${var.project[count.index]}_dev"
  description = "Developers of the ${var.project[count.index]} project."
  count = length(var.project)
}

//admin - project admin
//dev - can deploy to project, not approve
//release manager - can approve, but not deploy
//rg for read access to org level connectors