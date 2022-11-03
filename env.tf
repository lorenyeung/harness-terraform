resource "harness_platform_environment" "dev" {
  identifier = "dev"
  name   = "dev"
  org_id = var.org
  project_id = var.project
  type   = "PreProduction"
}

resource "harness_platform_infrastructure" "k8s_dev" {
  identifier          = ""
  project_id          = ""
  org_id              = ""
  name                = "k8s-dev"
  //app_id              = harness_application.demo.id
  env_id              = harness_platform_environment.dev.identifier
  type                = "KUBERNETES_CLUSTER"
  deployment_type     = "KUBERNETES"
  yaml                = ""
 
/*  kubernetes {
    cloud_provider_name = harness_cloudprovider_kubernetes.demo.name
    namespace           = harness_environment.dev.name
    release_name        = "$${service.name}"
  }*/
}

resource "harness_platform_environment" "stage" {
  identifier = "stage"
  name   = "stage"
  org_id = var.org
  project_id = var.project
  type   = "PreProduction"
}

resource "harness_platform_infrastructure" "k8s_stage" {
  identifier          = ""
  project_id          = ""
  org_id              = ""
  name                = "k8s-stage"
  //app_id              = harness_application.demo.id
  env_id              = harness_platform_environment.stage.identifier
  type                = "KUBERNETES_CLUSTER"
  deployment_type     = "KUBERNETES"
  yaml                = ""

/*  kubernetes {
    cloud_provider_name = harness_cloudprovider_kubernetes.demo.name
    namespace           = harness_environment.stage.name
    release_name        = "$${service.name}"
  }*/
}

resource "harness_platform_environment" "prod" {
  identifier = "prod"
  name   = "prod"
  org_id = var.org
  project_id = var.project
  type   = "Production"
}

resource "harness_platform_infrastructure" "k8s_prod" {
  identifier          = ""
  project_id          = ""
  org_id              = ""
  name                = "k8s-prod"
  //app_id              = harness_application.demo.id
  env_id              = harness_platform_environment.prod.identifier
  type                = "KUBERNETES_CLUSTER"
  deployment_type     = "KUBERNETES"
  yaml                = ""

/*  kubernetes {
    cloud_provider_name = harness_cloudprovider_kubernetes.demo.name
    namespace           = harness_environment.prod.name
    release_name        = "$${service.name}"
  }*/
}

