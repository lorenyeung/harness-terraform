####################
#
# Harness Connector AWS Cloud Setup
#
####################
resource "harness_platform_connector_aws" "aws" {

  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier
  # [Required] (String) Name of the resource.
  name = var.name
  # [Optional] (String) Description of the resource.
  description = var.description
  # [Optional] (Block List, Max: 1) Inherit credentials from the delegate
  # dynamic "inherit_from_delegate" {
  #   for_each = (
  #     var.aws_credentials != {}
  #     ?
  #     length(var.aws_credentials) > 0
  #     ?
  #     [var.aws_credentials]
  #     :
  #     []
  #     :
  #     []
  #   )
  #   # [Required] (Set of String) Tags to filter delegates for connection.
  #   content {
  #   delegate_selectors = var.delegate_selectors
  #   }    
  # }

  dynamic "irsa" {
    for_each = (
      var.aws_credentials != {}
      ?
      length(var.aws_credentials) > 0
      ?
      [var.aws_credentials]
      :
      []
      :
      []
    )
    content {
      # (String) Client Id of the ManagedIdentity resource.
      delegate_selectors = var.delegate_selectors
    }
  }

  # [Optional] (Block List, Max: 1) Use IAM role for service accounts
#   dynamic "manual" {
#     for_each = (
#       var.aws_credentials != {}
#       ?
#       var.aws_credentials == true
#       ?
#       [var.aws_credentials]
#       :
#       []
#       :
#       []
#     )
#     content {
# # req
#       secret_key_ref = var.secret_key_ref
#   # opt
#       access_key = var.access_key
#   # opt
#       access_key_ref = var.access_key_ref
#     }
#   }

  dynamic "cross_account_access" {
    for_each = (
      var.aws_credentials != {}
      ?
      length(keys(var.aws_credentials)) > 0
      ?
      [var.aws_credentials]
      :
      []
      :
      []
    )
    content {
     # [Required] (String) The Amazon Resource Name (ARN) of the role that you want to assume. This is an IAM role in the target AWS account.
     role_arn = cross_account_access.value.role_arn
     # [Optional] (String) If the administrator of the account to which the role belongs provided you with an external ID, then enter that value
     external_id = cross_account_access.value.external_id
    }
  }

  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id
  # [Optional] (Set of String) Tags to associate with the resource.
  tags = local.common_tags

  # [Required] (Block List, Min: 1, Max: 1) Contains Azure connector credentials.
  # dynamic "credentials" {
  #   for_each = (
  #     var.aws_credentials != {}
  #     ?
  #     length(keys(var.aws_credentials)) > 0
  #     ?
  #     [var.aws_credentials]
  #     :
  #     []
  #     :
  #     []
  #   )

  #   # compact(flatten([var.aws_credentials]))
  #   content {
  #     type = (
  #       credentials.value.type == "delegate"
  #       ?
  #       "InheritFromDelegate"
  #       :
  #       "ManualConfig"
  #     )

  #       # [Optional] (Block List, Max: 1) option if you want to use one AWS account for the connection, but you want to deploy or build in a different AWS account

  #     # Manual Azure connection block
  #     # Conditionally executed when the credential.type == "service_principal"
  #     dynamic "azure_manual_details" {
  #       for_each = lookup(credentials.value, "type", "delegate") == "service_principal" ? [1] : []
  #       content {
  #         # [Required] (String) The Azure Active Directory (AAD) directory ID where you created your application.
  #         tenant_id = credentials.value.tenant_id
  #         # [Required] (String) Application ID of the Azure App.
  #         application_id = credentials.value.client_id
  #         auth {
  #           # [Required] (String) Type can either be Certificate or Secret.
  #           type = title(credentials.value.secret_kind)
  #           dynamic "azure_client_key_cert" {
  #             for_each = lower(credentials.value.secret_kind) == "certificate" ? [credentials.value.secret_kind] : []
  #             content {
  #               # (String) Reference of the secret for the certificate.
  #               # To reference a secret at the organization scope:
  #               #  - prefix 'org' to the expression: org.{identifier}.
  #               # To reference a secret at the account scope:
  #               # - prefix 'account` to the expression: account.{identifier}.
  #               certificate_ref = (
  #                 lookup(credentials.value, "secret_location", "project") != "project"
  #                 ?
  #                 "${credentials.value.secret_location}.${lower(replace(credentials.value.secret_name, " ", ""))}"
  #                 :
  #                 lower(replace(credentials.value.secret_name, " ", ""))
  #               )
  #             }
  #           }
  #           dynamic "azure_client_secret_key" {
  #             for_each = lower(credentials.value.secret_kind) == "secret" ? [credentials.value.secret_kind] : []
  #             content {
  #               # (String) Reference of the secret for the secret key.
  #               # To reference a secret at the organization scope:
  #               #  - prefix 'org' to the expression: org.{identifier}.
  #               # To reference a secret at the account scope:
  #               #  - prefix 'account` to the expression: account.{identifier}.
  #               secret_ref = (
  #                 lookup(credentials.value, "secret_location", "project") != "project"
  #                 ?
  #                 "${credentials.value.secret_location}.${lower(replace(credentials.value.secret_name, " ", ""))}"
  #                 :
  #                 lower(replace(credentials.value.secret_name, " ", ""))
  #               )
  #             }
  #           }
  #         }
  #       }
  #     }
  #     # Delegate based Azure connection block
  #     # Conditionally executed when the credential.type == "delegate"
  #     dynamic "azure_inherit_from_delegate_details" {
  #       for_each = lookup(credentials.value, "type", "manual") == "delegate" ? [1] : []
  #       content {
  #         auth {
  #           # [Required] (String) Type can either be SystemAssignedManagedIdentity or UserAssignedManagedIdentity.
  #           type = (
  #             lookup(credentials.value, "delegate_auth", null) != null
  #             ?
  #             lookup({ system = "SystemAssignedManagedIdentity", user = "UserAssignedManagedIdentity" }, credentials.value.delegate_auth, "INVALID")
  #             :
  #             "SystemAssignedManagedIdentity"
  #           )
  #           dynamic "azure_msi_auth_ua" {
  #             for_each = compact(flatten([lookup(credentials.value, "client_id", "")]))
  #             content {
  #               # (String) Client Id of the ManagedIdentity resource.
  #               client_id = credentials.value.client_id
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

}

# When creating a new Connector, there is a potential race-condition
# as the connector comes up.  This resource will introduce
# a slight delay in further execution to wait for the resources to
# complete.
resource "time_sleep" "connector_setup" {
  depends_on = [
    harness_platform_connector_aws.aws
  ]

  create_duration  = "15s"
  destroy_duration = "15s"
}
