resource "harness_platform_usergroup" "project_admin" {
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id
  identifier = "${harness_platform_project.example.id}_admin"
  name        = "${harness_platform_project.example.id}_admin"
  description = "Administrators of the ${harness_platform_project.example.id} project."  
  
}

resource "harness_platform_role_assignments" "project_admin" {
  identifier                = "${harness_platform_project.example.id}_admin_role_assign"
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = "_project_admin"
  principal {
    identifier = harness_platform_usergroup.project_admin.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
  
}

resource "harness_platform_usergroup" "project_developer" {
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id  
  identifier = "${harness_platform_project.example.id}_dev"
  name        = "${harness_platform_project.example.id}_dev"
  description = "Developers of the ${harness_platform_project.example.id} project."
  
}

resource "harness_platform_role_assignments" "project_developer" {
  identifier                = "${harness_platform_project.example.id}_dev_role_assign"
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = "_pipeline_executor"
  principal {
    identifier = harness_platform_usergroup.project_developer.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
  
}

resource "harness_platform_usergroup" "release_manager" {
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id  
  identifier = "${harness_platform_project.example.id}_release_manager"
  name        = "${harness_platform_project.example.id}_release_manager"
  description = "Release managers of the ${harness_platform_project.example.id} project."
  
}

resource "harness_platform_role_assignments" "release_manager" {
  identifier                = "${harness_platform_project.example.id}_release_role_assign"
  org_id                    = harness_platform_project.example.org_id
  project_id                = harness_platform_project.example.id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = "_pipeline_executor"
  principal {
    identifier = harness_platform_usergroup.release_manager.id
    type       = "USER_GROUP"
  }
  disabled = false
  managed  = false
  
}

//admin - project admin
//dev - can deploy to project, not approve
//release manager - can approve, but not deploy
//rg for read access to org level connectors