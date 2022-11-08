
resource "harness_platform_organization" "example" {
  identifier = var.org[count.index]
  name       = var.org[count.index]
  count      = length(var.org)
}

resource "harness_platform_project" "example" {
  org_id     = harness_platform_organization.example[count.index].id
  identifier = var.project[count.index]
  name       = var.project[count.index]
  count      = length(var.project)
}

resource "harness_platform_service" "example" {
  identifier  = "cd_example_service_${harness_platform_project.example[count.index].id}"
  name        = "cd_example_service_${harness_platform_project.example[count.index].id}"
  description = "test"
  org_id      = harness_platform_organization.example[count.index].id
  project_id  = harness_platform_project.example[count.index].id
  count       = length(var.project)
  yaml        = <<-EOT
          service:
            name: "cd_example_service_${harness_platform_project.example[count.index].id}"
            identifier: "cd_example_service_${harness_platform_project.example[count.index].id}"
            description: "test"
            tags: {}
            serviceDefinition:
              spec:
                manifests:
                  - manifest:
                      identifier: nginx_manifest
                      type: HelmChart
                      spec:
                        store:
                          type: Http
                          spec:
                            connectorRef: account.${harness_platform_connector_helm.tf_bitnami.id}
                        chartName: nginx
                        chartVersion: <+input>
                        helmVersion: V3
                        skipResourceVersioning: false
                artifacts:
                  primaryArtifactRef: <+input>
                  sources:
                    - spec:
                        connectorRef: account.${harness_platform_connector_docker.tf_dockerhub.id}
                        imagePath: bitnami/nginx
                        tag: latest
                      identifier: nginx_docker  
                      type: DockerRegistry
                  primary:
                    sources:
                      - spec:
                          connectorRef: account.tf_dockerhub
                          imagePath: bitnami/nginx
                          tag: <+input>
                        identifier: nginx_docker
                        type: DockerRegistry
                    primaryArtifactRef: <+input>    
              type: Kubernetes
  EOT
}
