# Variable Management for Harness Connectors
variable "name" {
  type        = string
  description = "[Required] Provide a connector name.  Must be two or more characters"

  validation {
    condition = (
      length(var.name) > 2
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Provide a connector name.  Must be two or more characters.
        EOF
  }
}

variable "organization_id" {
  type        = string
  description = "[Required] Provide an organization reference ID.  Must exist before execution"
  default     = null

  validation {
    condition = (
      anytrue([
        can(regex("^([a-zA-Z0-9_]*)", var.organization_id)),
        var.organization_id == null
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Provide an organization name.  Must exist before execution.
        EOF
  }
}

variable "project_id" {
  type        = string
  description = "[Required] Provide an project reference ID.  Must exist before execution"
  default     = null

  validation {
    condition = (
      anytrue([
        can(regex("^([a-zA-Z0-9_]*)", var.project_id)),
        var.project_id == null
      ])
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] Provide an project name.  Must exist before execution.
        EOF
  }
}

variable "description" {
  type        = string
  description = "[Optional] (String) Description of the resource."
  default     = "Harness Connector created via Terraform"

  validation {
    condition = (
      length(var.description) > 6
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide an connector description.  Must be six or more characters.
        EOF
  }
}

# [Optional] (String) Specifies the Connector type, which is AZURE by default.
variable "type" {
  type        = string
  description = "[Optional] (String) Specifies the Connector type, which is AZURE by default. Can either be azure, us_government, github or kubernetes"
  default     = "azure"

  validation {
    condition = (
      contains(["azure", "us_government", "github", "kubernetes"], lower(var.type))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Required] (String) Secret Type - One of 'azure','us_government' or 'github'
        EOF
  }
}

# [Optional] (Set of String) Tags to filter delegates for connection.
variable "delegate_selectors" {
  type        = list(string)
  description = "[Optional] (Set of String) Tags to filter delegates for connection."
  default     = []
}

# [Optional] (Boolean) Execute on delegate or not.
variable "execute_on_delegate" {
  type        = bool
  description = "[Optional] (Boolean) Execute on delegate or not."
  default     = true
}

# [Optional] (Map) Azure Connector Credentials.
variable "azure_credentials" {
  type        = map(any)
  description = "[Optional] (Map) Azure Connector Credentials."
  default     = {}

  validation {
    condition = (
      anytrue([
        length(var.azure_credentials) == 0,
        alltrue([
          contains(["delegate", "service_principal"], lookup(var.azure_credentials, "type", "invalid")),
          (
            lookup(var.azure_credentials, "type", "invalid") == "delegate"
            ?
            lookup(var.azure_credentials, "delegate_auth", null) != null
            ?
            alltrue([
              contains(["system", "user"], lower(var.azure_credentials.delegate_auth)),
              (
                lower(var.azure_credentials.delegate_auth) == "user"
                ?
                can(regex("^([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})$", lookup(var.azure_credentials, "client_id", null)))
                :
                true
              )
            ])
            :
            true
            :
            true
          ),
          (
            lookup(var.azure_credentials, "type", "invalid") == "service_principal"
            ?
            alltrue([
              can(regex("^([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})$", lookup(var.azure_credentials, "tenant_id", null))),
              can(regex("^([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})$", lookup(var.azure_credentials, "client_id", null))),
              contains(["secret", "certificate"], lower(lookup(var.azure_credentials, "secret_kind", "invalid"))),
              can(regex("^(account|org|project)", lookup(var.azure_credentials, "secret_location", "project"))),
              can(regex("^([a-zA-Z0-9 _-])+$", lookup(var.azure_credentials, "secret_name", null)))
            ])
            :
            true
          )
        ])

      ])
    )
    error_message = <<EOF
        Validation of an object failed. Organizations must include:
            * type - [Required] (String) Type can either be delegate or service_principal.
            * delegate_auth - [Conditionally Required] (String) Type can either be system or user. Mandatory if type == delegate
            * tenant_id - [Conditionally Required] (String) Azure Tenant ID. Mandatory if type == service_principal
            * client_id - [Conditionally Required] (String) Azure Service Principal or Managed Identity ID. Mandatory if type == delegate && delegate_auth == user OR type == service_principal
            * secret_kind - [Conditionally Required] (String) Azure Client Authentication model can be either secret or certifiate. Mandatory if type == service_principal
            * secret_location - [Optional] (String) Location within Harness that the secret is stored.  Supported values are "account", "org", or "project"
            * secret_name - [Conditionally Required] (String) Existing Harness Secret containing Azure Client Authentication details. Mandatory if type == service_principal
              - NOTE: Secrets stored at the Account or Organization level must include correct value for the secret_location
        EOF
  }
}

# GitHub Specific Variables


# [Optional] (Boolean) Execute on delegate or not.
variable "url" {
  type        = string
  description = "[Required] (String) URL of the Githubhub repository or account."
  default     = null
}

variable "connection_type" {
  type        = string
  description = "[Required] (String) Whether the connection we're making is to a github repository or a github account. Valid values are Account, Repo."
  default     = null
}

# [Optional] (Boolean) Execute on delegate or not.
variable "validation_repo" {
  type        = string
  description = "[Optional] (String) Repository to test the connection with. This is only used when connection_type is Account."
  default     = null
}

# [Optional] (Map) GitHub Connector Credentials.
variable "github_credentials" {
  type        = map(any)
  description = "[Optional] (Map) GitHub Connector Credentials."
  default     = {}
}

# Kubernetes Connector Details
# [Optional] (Map) Kubernetes Connector Credentials.
variable "kubernetes_credentials" {
  type        = any
  description = "[Optional] (Map) Kubernetes Connector Credentials."
  default     = {}
}

variable "tags" {
  type        = map(any)
  description = "[Optional] Provide a Map of Tags to associate with the connector"
  default     = {}

  validation {
    condition = (
      length(keys(var.tags)) == length(values(var.tags))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a Map of Tags to associate with the connector
        EOF
  }
}

variable "global_tags" {
  type        = map(any)
  description = "[Optional] Provide a Map of Tags to associate with the connector and resources created"
  default     = {}

  validation {
    condition = (
      length(keys(var.global_tags)) == length(values(var.global_tags))
    )
    error_message = <<EOF
        Validation of an object failed.
            * [Optional] Provide a Map of Tags to associate with the connector and resources created
        EOF
  }
}
