####################
#
# Harness Connector Azure Cloud Outputs
#
####################
# 2023-03-16
# This output is being deprecated and replaced by the output
# labeled `details`
output "connector_details" {
  depends_on = [
    time_sleep.connector_setup
  ]
  value       = harness_platform_connector_azure_cloud_provider.azure
  description = "Details for the created Harness Connector"
}

output "details" {
  depends_on = [
    time_sleep.connector_setup
  ]
  value       = harness_platform_connector_azure_cloud_provider.azure
  description = "Details for the created Harness Connector"
}
