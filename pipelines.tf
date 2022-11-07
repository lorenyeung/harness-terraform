
resource "harness_platform_pipeline" "example" {
  identifier = "cd_example_pipeline"
  name       = "cd_example_pipeline"
  org_id     = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
  count = length(var.project)
  yaml       = <<-EOT
      pipeline:
          name: cd_example_pipeline
          identifier: "cd_example_pipeline"
          allowStageExecutions: false
          projectIdentifier: ${harness_platform_project.example[count.index].id}
          orgIdentifier: ${harness_platform_organization.example[count.index].id}
          tags: {}
          stages:
              - stage:
                  name: deploy
                  identifier: deploy
                  description: ""
                  type: Deployment
                  spec:
                      serviceConfig:
                          serviceRef: cd_example_service_${harness_platform_project.example[count.index].id}
                          serviceDefinition:
                              type: Kubernetes
                              spec:
                                  variables: []
                      infrastructure:
                          environmentRef: dev
                          infrastructureDefinition:
                              type: KubernetesDirect
                              spec:
                                  connectorRef: k8s_connector_${harness_platform_project.example[count.index].id}
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