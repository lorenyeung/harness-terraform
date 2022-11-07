
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
            name: deploy_dev
            identifier: deploy_dev
            description: ""
            type: Deployment
            spec:
                serviceConfig:
                    serviceRef: ${harness_platform_service.example[count.index].id}
                    serviceDefinition:
                        type: Kubernetes
                        spec:
                            variables: []
                infrastructure:
                    environmentRef: ${harness_platform_environment.dev[count.index].id}
                    infrastructureDefinition:
                        type: KubernetesDirect
                        spec:
                            connectorRef: ${harness_platform_connector_kubernetes.example[count.index].id}
                            namespace: ${harness_platform_environment.dev[count.index].id}
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
        - stage:
            name: deploy_prod
            identifier: deploy_prod
            description: ""
            type: Deployment
            spec:
                serviceConfig:
                    useFromStage:
                        stage: deploy_dev
                infrastructure:
                    environmentRef: ${harness_platform_environment.prod[count.index].id}
                    infrastructureDefinition:
                        type: KubernetesDirect
                        spec:
                            connectorRef: ${harness_platform_connector_kubernetes.example[count.index].id}
                            namespace: ${harness_platform_environment.prod[count.index].id}
                            releaseName: release-<+INFRA_KEY>
                    allowSimultaneousDeployments: false
                execution:
                    steps:
                    - step:
                        type: K8sCanaryDeploy
                        name: canary
                        identifier: canary
                        spec:
                            skipDryRun: true
                            instanceSelection:
                                type: Count
                                spec:
                                    count: 2
                        timeout: 10m
                        loopingStrategyEnabled: false
                    - step:
                        type: HarnessApproval
                        name: manual-approval
                        identifier: manualapproval
                        spec:
                            approvalMessage: Please review the following information and approve the pipeline progression
                            includePipelineExecutionHistory: true
                            approvers:
                                userGroups:
                                    - terra_project_release_manager
                                minimumCount: 1
                                disallowPipelineExecutor: false
                            approverInputs: []
                        timeout: 1d
                    - step:
                        type: K8sCanaryDelete
                        name: delete
                        identifier: delete
                        spec:
                            skipDryRun: false
                        timeout: 10m
                    - step:
                        type: K8sRollingDeploy
                        name: rollout
                        identifier: rollout
                        spec:
                            skipDryRun: false
                        timeout: 10m
                    rollbackSteps:
                    - step:
                        name: Rollback Rollout Deployment
                        identifier: rollbackRolloutDeployment
                        type: K8sRollingRollback
                        timeout: 10m
                        spec: {}
                tags: {}
                failureStrategies:
                - onFailure:
                    errors:
                        - AllErrors
                    action:
                        type: StageRollback
  EOT
}