####################
#
# Harness Structure Provider Requirements
#
####################
terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

## Remote Pipeline template
resource "harness_platform_template" "pipeline_template_remote" {
  identifier = "identifier_template_data4"
  org_id     = "default"
  project_id = "technical_exercise"
  name       = "datadog-private-locations-managed2"
  comments   = "comments"
  version    = "test"
  is_stable  = true
  template_yaml = <<-EOT
template:
  name: datadog-private-locations-managed2
  identifier: identifier_template_data3
  orgIdentifier: default
  projectIdentifier: technical_exercise
  versionLabel: test
  type: Stage
  spec:
    type: Deployment
    variables:
      - name: gitRef
        type: String
        value: <+input>
      - name: infrastructureRef
        type: String
        value: <+input>
    spec:
      deploymentType: Kubernetes
      service:
        serviceRef: datadog_private_locations_managed
      environment:
        environmentRef: <+stage.variables.environmentRef>
        deployToAll: false
        infrastructureDefinitions:
          - identifier: <+stage.variables.infrastructureRef>
            inputs:
              identifier: <+stage.variables.infrastructureRef>
              type: KubernetesDirect
              spec:
                namespace: dd-synthetics
                releaseName: dd-synthetics-<+INFRA_KEY>
      execution:
        steps:
          - step:
              type: K8sApply
              name: Apply
              identifier: apply
              spec:
                filePaths:
                  - manifests/condor
                skipDryRun: false
                skipSteadyStateCheck: false
                skipRendering: false
                overrides: []
              timeout: 10m
        rollbackSteps: []
      serviceDependencies: []
    failureStrategies:
      - onFailure:
          errors:
            - AllErrors
          action:
            type: StageRollback

  EOT
}
