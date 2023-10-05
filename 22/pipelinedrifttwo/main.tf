variable "pipeline_list" {
    type = list(map(string))
    default = [
        {
            name = "terraform"
            description = "Pipeline for alpha"
            yaml_file = "files/pipeline_alpha.yml"
        },
        {
            name = "bravo"
            description = "Pipeline for bravo"
            yaml_file = "files/pipeline_bravo.yml"
        },
                {
            name = "template_test_2"
            description = "Pipeline for alpha"
            yaml_file = "files/pipeline_alpha.yml"
        },
        {
            name = "ci_connector_test"
            description = "Pipeline for alpha"
            yaml_file = "files/pipeline_alpha.yml"
        },
        {
            name = "hello"
            description = "Pipeline for alpha"
            yaml_file = "files/pipeline_alpha.yml"
        },
        {
            name = "charlie"
            description = "Pipeline for charlie"
            yaml_file = "files/pipeline_charlie.yml"
        }
    ]
}

module "pipelines" {
  source = "git@github.com:harness-community/terraform-harness-content.git//modules/pipelines"
  for_each = { for pipeline in var.pipeline_list : pipeline.name => pipeline }

  name        = each.value.name
  description = each.value.description
  yaml_file   = each.value.yaml_file
  organization_id="defaultorg"
  project_id="foo"
}
