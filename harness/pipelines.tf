
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
                deploymentType: Kubernetes
                service:
                    serviceRef: ${harness_platform_service.example[count.index].id}
                    serviceInputs:
                        serviceDefinition:
                            type: Kubernetes
                            spec:
                                manifests:
                                    - manifest:
                                        identifier: nginx_manifest
                                        type: HelmChart
                                        spec:
                                            chartVersion: <+input>
                                artifacts:
                                    primaryArtifactRef: <+input>
                                    primary:
                                        primaryArtifactRef: <+input>
                                        sources: <+input>        
                environment:
                    environmentRef: ${harness_platform_environment.dev[count.index].id}
                    deployToAll: false
                    infrastructureDefinitions:
                        - identifier: ${harness_platform_infrastructure.k8s_dev[count.index].id}
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
                deploymentType: Kubernetes
                service:
                    useFromStage:
                        stage: deploy_dev
                environment:
                    environmentRef: ${harness_platform_environment.prod[count.index].id}
                    deployToAll: false
                    infrastructureDefinitions:
                        - identifier: ${harness_platform_infrastructure.k8s_prod[count.index].id}
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
                        - step:
                            type: HarnessApproval
                            name: Approval
                            identifier: Approval
                            spec:
                                approvalMessage: Please review the following information and approve the pipeline progression
                                includePipelineExecutionHistory: true
                                approvers:
                                    userGroups:
                                        - terra_project_release_manager
                                    minimumCount: 1
                                    disallowPipelineExecutor: true
                                approverInputs: []
                            timeout: 1d
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
                                name: Canary Delete
                                identifier: rollbackCanaryDelete
                                type: K8sCanaryDelete
                                timeout: 10m
                                spec: {}
                            - step:
                                name: Rolling Rollback
                                identifier: rollingRollback
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