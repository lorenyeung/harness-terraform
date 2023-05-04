locals {
  connector_details = flatten([
    (
      local.fmt_connector_type == "azure"
      ?
      jsondecode(jsonencode(harness_platform_connector_azure_cloud_provider.azure))
      :
      []
      ), (
      local.fmt_connector_type == "github"
      ?
      jsondecode(jsonencode(harness_platform_connector_github.github))
      :
      []
      ), (
      local.fmt_connector_type == "kubernetes"
      ?
      jsondecode(jsonencode(harness_platform_connector_kubernetes.kubernetes))
      :
      []
    )
  ])
}


output "connector_details" {
  value = (
    length(local.connector_details) > 0
    ?
    local.connector_details[0]
    :
    null
  )
}

output "success" {
  depends_on = [
    time_sleep.connector_setup
  ]
  value = true
}
