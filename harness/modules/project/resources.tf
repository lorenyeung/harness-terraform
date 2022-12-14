resource "harness_platform_project" "example" {
  org_id     = var.org
  identifier = var.project
  name       = var.project
}

resource "harness_platform_service" "example" {
  identifier  = "cd_example_service_${harness_platform_project.example.id}"
  name        = "cd_example_service_${harness_platform_project.example.id}"
  description = "test"
  org_id      = harness_platform_project.example.org_id
  project_id  = harness_platform_project.example.id
  yaml        = <<-EOT
          service:
            name: "cd_example_service_${harness_platform_project.example.id}"
            identifier: "cd_example_service_${harness_platform_project.example.id}"
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
                            connectorRef: ${harness_platform_connector_helm.tf_bitnami.id}
                        chartName: nginx
                        chartVersion: <+input>
                        helmVersion: V3
                        skipResourceVersioning: false
                artifacts:
                  primaryArtifactRef: <+input>
                  sources:
                    - spec:
                        connectorRef: ${harness_platform_connector_docker.tf_dockerhub.id}
                        imagePath: bitnami/nginx
                        tag: latest
                      identifier: nginx_docker  
                      type: DockerRegistry
                  primary:
                    sources:
                      - spec:
                          connectorRef: ${harness_platform_connector_docker.tf_dockerhub.id}
                          imagePath: bitnami/nginx
                          tag: <+input>
                        identifier: nginx_docker
                        type: DockerRegistry
                    primaryArtifactRef: <+input>    
              type: Kubernetes
  EOT
}
