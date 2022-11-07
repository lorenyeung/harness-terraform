
resource "harness_platform_pipeline" "example" {
  identifier = "cd_example_pipeline"
  name       = "cd_example_pipeline"
  org_id     = var.org[count.index]
  project_id = var.project[count.index]
  count = length(var.project)
  yaml       = <<-EOT
      pipeline:
          name: cd_example_pipeline
          identifier: "cd_example_pipeline"
          allowStageExecutions: false
          projectIdentifier: ${var.project[count.index]}
          orgIdentifier: ${var.org[count.index]}
          tags: {}
          stages:
              - stage:
                  name: deploy
                  identifier: deploy
                  description: ""
                  type: Deployment
                  spec:
                      serviceConfig:
                          serviceRef: cd_example_service_${var.project[count.index]}
                          serviceDefinition:
                              type: Kubernetes
                              spec:
                                  variables: []
                      infrastructure:
                          environmentRef: dev
                          infrastructureDefinition:
                              type: KubernetesDirect
                              spec:
                                  connectorRef: k8s_connector_${var.project[count.index]}
                                  namespace: dev
                                  releaseName: release-<+INFRA_KEY>
                          allowSimultaneousDeployments: false
                      execution:
                          steps:
                              - stepGroup:
                                      name: Canary Deployment
                                      identifier: canaryDepoyment
                                      steps:
                                          - step:
                                              name: Canary Deployment
                                              identifier: canaryDeployment
                                              type: K8sCanaryDeploy
                                              timeout: 10m
                                              spec:
                                                  instanceSelection:
                                                      type: Count
                                                      spec:
                                                          count: 1
                                                  skipDryRun: false
                                          - step:
                                              name: Canary Delete
                                              identifier: canaryDelete
                                              type: K8sCanaryDelete
                                              timeout: 10m
                                              spec: {}
                                      rollbackSteps:
                                          - step:
                                              name: Canary Delete
                                              identifier: rollbackCanaryDelete
                                              type: K8sCanaryDelete
                                              timeout: 10m
                                              spec: {}
                              - stepGroup:
                                      name: Primary Deployment
                                      identifier: primaryDepoyment
                                      steps:
                                          - step:
                                              name: Rolling Deployment
                                              identifier: rollingDeployment
                                              type: K8sRollingDeploy
                                              timeout: 10m
                                              spec:
                                                  skipDryRun: false
                                      rollbackSteps:
                                          - step:
                                              name: Rolling Rollback
                                              identifier: rollingRollback
                                              type: K8sRollingRollback
                                              timeout: 10m
                                              spec: {}
                          rollbackSteps: []
                  tags: {}
                  failureStrategies:
                      - onFailure:
                              errors:
                                  - AllErrors
                              action:
                                  type: StageRollback
  EOT
}