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

resource "harness_platform_infrastructure" "k8s_dev" {
  identifier          = "k8s_dev_infra"
  project_id          = var.project[count.index]
  org_id              = var.org[count.index]
  name                = "k8s-dev"
  env_id              = "dev"
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_dev_infra"
      identifier: k8s_dev_infra
      description: "dev"
      tags:
        terraform: "terraform"
        dev: "dev"
      orgIdentifier: ${var.org[count.index]}
      projectIdentifier: ${var.project[count.index]}
      environmentRef: "dev"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${var.project[count.index]}
        namespace: dev
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)
}

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

resource "harness_platform_infrastructure" "k8s_stage" {
  identifier          = "k8s_stage_infra"
  project_id          = var.project[count.index]
  org_id              = var.org[count.index]
  name                = "k8s-stage"
  env_id              = "stage"
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_stage_infra"
      identifier: "k8s_stage_infra"
      description: "stage"
      tags:
        terraform: "terraform"
        stage: "stage"
      orgIdentifier: ${var.org[count.index]}
      projectIdentifier: ${var.project[count.index]}
      environmentRef: "stage"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${var.project[count.index]}
        namespace: stage
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)    
}

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

resource "harness_platform_infrastructure" "k8s_prod" {
  identifier          = "k8s_prod_infra"
  project_id          = var.project[count.index]
  org_id              = var.org[count.index]
  name                = "k8s-prod"
  env_id              = "prod"
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_prod_infra"
      identifier: "k8s_prod_infra"
      description: "prod"
      tags:
        terraform: "terraform"
        prod: "prod"
      orgIdentifier: ${var.org[count.index]}
      projectIdentifier: ${var.project[count.index]}
      environmentRef: "prod"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${var.project[count.index]}
        namespace: prod
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)
}