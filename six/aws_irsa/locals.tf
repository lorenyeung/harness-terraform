locals {

  required_tags = [
    "created_by:Terraform"
  ]
  # Harness Tags are read into Terraform as a standard Map entry but needs to be
  # converted into a list of key:value entries
  global_tags = [for k, v in var.global_tags : "${k}:${v}"]
  # Harness Tags are read into Terraform as a standard Map entry but needs to be
  # converted into a list of key:value entries
  tags = [for k, v in var.tags : "${k}:${v}"]

  common_tags = flatten([
    local.tags,
    local.global_tags,
    local.required_tags
  ])

  # Secrets Management
  secret_types = [
    "file",
    "text",
    "sshkey"
  ]

  fmt_connector_type = lower(replace(replace(var.type, "_", "-"), "-", ""))

  fmt_identifier = (
    lower(
      replace(
        replace(
          replace(
            var.name,
            " ",
            "_"
          ),
          "_",
          "-"
        ),
        "-",
        ""
      )
    )
  )

  azure_environment_type = (
    lower(var.type) == "us_government"
    ?
    "AZURE_US_GOVERNMENT"
    :
    "AZURE"
  )
}
