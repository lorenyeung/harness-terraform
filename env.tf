resource "harness_platform_environment" "dev" {
  identifier = "dev"
  name   = "dev"
  org_id = var.org[count.index]
  project_id = var.project[count.index]
  type   = "PreProduction"
  depends_on = [
    harness_platform_project.example
  ]
  count = length(var.project)
}

/*
resource "harness_platform_infrastructure" "k8s_dev" {
  identifier          = "k8s_dev_infra"
  project_id          = var.project
  org_id              = var.org
  name                = "k8s-dev"
  env_id              = harness_platform_environment.dev.identifier
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: ${harness_platform_environment.dev.name}
      identifier: ${harness_platform_environment.dev.identifier}
      description: "dev"
      tags:
        dev: "dev"
      orgIdentifier: ${var.org}
      projectIdentifier: ${var.project}
      environmentRef: ${harness_platform_environment.dev.identifier}
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: account.colimak8s
        namespace: dev
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
}
*/

resource "harness_platform_environment" "stage" {
  identifier = "stage"
  name   = "stage"
  org_id = var.org[count.index]
  project_id = var.project[count.index]
  type   = "PreProduction"
  depends_on = [
    harness_platform_project.example
  ]
  count = length(var.project)
}
/*
resource "harness_platform_infrastructure" "k8s_stage" {
  identifier          = "k8s_stage_infra"
  project_id          = var.project
  org_id              = var.org
  name                = "k8s-stage"
  env_id              = harness_platform_environment.dev.identifier
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: ${harness_platform_environment.stage.name}
      identifier: ${harness_platform_environment.stage.identifier}
      description: "stage"
      tags:
        stage: "stage"
      orgIdentifier: ${var.org}
      projectIdentifier: ${var.project}
      environmentRef: ${harness_platform_environment.stage.identifier}
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: account.colimak8s
        namespace: stage
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
}
*/

resource "harness_platform_environment" "prod" {
  identifier = "prod"
  name   = "prod"
  org_id = var.org[count.index]
  project_id = var.project[count.index]
  type   = "Production"
  depends_on = [
    harness_platform_project.example
  ]
  count = length(var.project)
}
/*
resource "harness_platform_infrastructure" "k8s_prod" {
  identifier          = "k8s_prod_infra"
  project_id          = var.project
  org_id              = var.org
  name                = "k8s-prod"
  env_id              = harness_platform_environment.prod.identifier
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: ${harness_platform_environment.prod.name}
      identifier: ${harness_platform_environment.prod.identifier}
      description: "prod"
      tags:
        prod: "prod"
      orgIdentifier: ${var.org}
      projectIdentifier: ${var.project}
      environmentRef: ${harness_platform_environment.prod.identifier}
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: account.colimak8s
        namespace: prod
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
}
*/

