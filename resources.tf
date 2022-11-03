
resource "harness_platform_organization" "example" {
  identifier = var.org[count.index]
  name       = var.org[count.index]
  count = length(var.org)
}

resource "harness_platform_project" "example" {
  identifier = var.project[count.index]
  name       = var.project[count.index]
  org_id     = var.org[count.index]
  depends_on = [
    harness_platform_organization.example
  ]
  count = length(var.project)
}

resource "harness_platform_pipeline" "example" {
  identifier = "terra_pipeline"
  name       = "name"
  org_id     = var.org[count.index]
  project_id = var.project[count.index]
  count = length(var.project)
  yaml       = <<-EOT
      pipeline:
          name: name
          identifier: "terra_pipeline"
          allowStageExecutions: false
          projectIdentifier: ${var.project[count.index]}
          orgIdentifier: ${var.org[count.index]}
          tags: {}
          stages:
              - stage:
                  name: dep
                  identifier: dep
                  description: ""
                  type: Deployment
                  spec:
                      serviceConfig:
                          serviceRef: service
                          serviceDefinition:
                              type: Kubernetes
                              spec:
                                  variables: []
                      infrastructure:
                          environmentRef: testenv
                          infrastructureDefinition:
                              type: KubernetesDirect
                              spec:
                                  connectorRef: testconf
                                  namespace: test
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
  depends_on = [
    harness_platform_project.example
  ]
}
