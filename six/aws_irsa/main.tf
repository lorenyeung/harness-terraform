# When creating a new Connector, there is a potential race-condition
# as the connector comes up.  This resource will introduce
# a slight delay in further execution to wait for the resources to
# complete.
resource "time_sleep" "connector_setup" {
  depends_on = [
    harness_platform_connector_azure_cloud_provider.azure,
    harness_platform_connector_github.github,
    harness_platform_connector_kubernetes.kubernetes
  ]

  create_duration  = "15s"
  destroy_duration = "15s"
}
