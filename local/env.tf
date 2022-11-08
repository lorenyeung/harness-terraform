resource "harness_platform_environment" "dev" {
  identifier = "dev"
  name   = "dev"
  project_id          = harness_platform_project.example[count.index].id
  org_id              = harness_platform_organization.example[count.index].id
  type   = "PreProduction"
  count = length(var.project)
}

resource "harness_platform_infrastructure" "k8s_dev" {
  identifier          = "k8s_dev_infra"
  project_id          = harness_platform_project.example[count.index].id
  org_id              = harness_platform_organization.example[count.index].id
  name                = "k8s-dev"
  env_id              = harness_platform_environment.dev[count.index].id
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_dev_infra"
      identifier: k8s_dev_infra
      description: "dev"
      tags:
        terraform: "terraform"
        dev: "dev"
      orgIdentifier: ${harness_platform_organization.example[count.index].id}
      projectIdentifier: ${harness_platform_project.example[count.index].id}
      environmentRef: "dev"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${harness_platform_project.example[count.index].id}
        namespace: dev
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)
}

resource "harness_platform_environment" "stage" {
  identifier = "stage"
  name   = "stage"
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
  type   = "PreProduction"
  count = length(var.project)
}

resource "harness_platform_infrastructure" "k8s_stage" {
  identifier          = "k8s_stage_infra"
  project_id          = harness_platform_project.example[count.index].id
  org_id              = harness_platform_organization.example[count.index].id
  name                = "k8s-stage"
  env_id              = harness_platform_environment.stage[count.index].id
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_stage_infra"
      identifier: "k8s_stage_infra"
      description: "stage"
      tags:
        terraform: "terraform"
        stage: "stage"
      orgIdentifier: ${harness_platform_organization.example[count.index].id}
      projectIdentifier: ${harness_platform_project.example[count.index].id}
      environmentRef: "stage"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${harness_platform_project.example[count.index].id}
        namespace: stage
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)    
}

resource "harness_platform_environment" "prod" {
  identifier = "prod"
  name   = "prod"
  org_id = harness_platform_organization.example[count.index].id
  project_id = harness_platform_project.example[count.index].id
  type   = "Production"
  count = length(var.project)
}

resource "harness_platform_infrastructure" "k8s_prod" {
  identifier          = "k8s_prod_infra"
  project_id          = harness_platform_project.example[count.index].id
  org_id              = harness_platform_organization.example[count.index].id
  name                = "k8s-prod"
  env_id              = harness_platform_environment.prod[count.index].id
  type                = "KubernetesDirect"
  yaml                = <<-EOT
    infrastructureDefinition:
      name: "k8s_prod_infra"
      identifier: "k8s_prod_infra"
      description: "prod"
      tags:
        terraform: "terraform"
        prod: "prod"
      orgIdentifier: ${harness_platform_organization.example[count.index].id}
      projectIdentifier: ${harness_platform_project.example[count.index].id}
      environmentRef: "prod"
      deploymentType: Kubernetes
      type: KubernetesDirect
      spec:
        connectorRef: k8s_connector_${harness_platform_project.example[count.index].id}
        namespace: prod
        releaseName: release-<+INFRA_KEY>
        allowSimultaneousDeployments: false
      EOT
  count = length(var.project)
}