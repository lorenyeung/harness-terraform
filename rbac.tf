resource "harness_platform_usergroup" "project_admin" {
  identifier = "${var.project[count.index]}_admin"
  name        = "${var.project[count.index]}_admin"
  description = "Administrators of the ${var.project[count.index]} project."  
  count = length(var.project)
#   permissions {

#     account_permissions = [
#       "CREATE_CUSTOM_DASHBOARDS"
#     ]

#     app_permissions {

#       all {
#         app_ids = [harness_application.demo.id]
#         actions = ["CREATE", "READ", "UPDATE", "DELETE"]
#       }

#     }
#   }
}

resource "harness_platform_usergroup" "project_developer" {
  identifier = "${var.project[count.index]}_dev"
  name        = "${var.project[count.index]}_dev"
  description = "Developers of the ${var.project[count.index]} project."
  count = length(var.project)
#   permissions {
#     account_permissions = [
#       "CREATE_CUSTOM_DASHBOARDS"
#     ]

#     app_permissions {

#       all {
#         app_ids = [harness_application.demo.id]
#         actions = ["READ"]
#       }

#       deployment {
#         app_ids = [harness_application.demo.id]
#         filters = ["NON_PRODUCTION_ENVIRONMENTS"]
#         actions = ["READ", "ROLLBACK_WORKFLOW", "EXECUTE_PIPELINE", "EXECUTE_WORKFLOW"]
#       }

#     }
#   }
}


//admin - project admin
//dev - can deploy to project, not approve
//release manager - can approve, but not deploy
//rg for read access to org level connectors