# connectors

## Example

```hcl
module "connectors-azure-cloud" {
  depends_on = [
    module.secrets-platform-key,
    module.secrets-github-authentication
  ]
  source = "../../connectors"

  name                = "azure"
  description         = "Default Azure Cloud Connection"
  type                = "azure"
  delegate_selectors  = ["harness-account"]
  execute_on_delegate = true
  azure_credentials = {
    type          = "delegate"
    delegate_auth = "user"
    client_id     = var.azure_client_id
  }
  tags = {
    purpose = "azure-connections"
  }
  global_tags = var.global_tags
}

module "connectors-github" {
  depends_on = [
    module.secrets-platform-key,
    module.secrets-github-authentication
  ]
  source = "../../connectors"

  name                = "Enterprise Code Repository"
  description         = "Harness Connector for GitHub created via Terraform"
  type                = "github"
  delegate_selectors  = ["harness-account"]
  execute_on_delegate = true
  url                 = var.github_url
  connection_type     = var.github_connection_type
  validation_repo     = var.github_validation_repo
  github_credentials = {
    type            = "http"
    username        = var.github_username
    secret_location = "account"
    secret_name     = "GitHub Authentication"
    api_secret_name = "GitHub Authentication"
  }
  tags = {
    purpose = "github-connections"
  }
  global_tags = var.global_tags
}

module "connectors-azure-aks" {
  depends_on = [
    module.secrets-platform-key,
    module.secrets-github-authentication
  ]
  source = "../../connectors"

  name                = "Harness Workloads AKS"
  description         = "Harness Connector for Kubernetes created via Terraform"
  type                = "kubernetes"
  delegate_selectors  = ["harness-account"]
  execute_on_delegate = true
  kubernetes_credentials = {
    type               = "delegate"
    delegate_selectors = ["harness-account"]
  }
  tags = {
    purpose = "coreci-connections"
  }
  global_tags = var.global_tags
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_harness"></a> [harness](#provider\_harness) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [harness_platform_connector_azure_cloud_provider.azure](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_azure_cloud_provider) | resource |
| [harness_platform_connector_github.github](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_github) | resource |
| [harness_platform_connector_kubernetes.kubernetes](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes) | resource |
| [time_sleep.connector_setup](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_credentials"></a> [azure\_credentials](#input\_azure\_credentials) | [Optional] (Map) Azure Connector Credentials. | `map(any)` | `{}` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | [Required] (String) Whether the connection we're making is to a github repository or a github account. Valid values are Account, Repo. | `string` | `null` | no |
| <a name="input_delegate_selectors"></a> [delegate\_selectors](#input\_delegate\_selectors) | [Optional] (Set of String) Tags to filter delegates for connection. | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | [Optional] (String) Description of the resource. | `string` | `"Harness Connector created via Terraform"` | no |
| <a name="input_execute_on_delegate"></a> [execute\_on\_delegate](#input\_execute\_on\_delegate) | [Optional] (Boolean) Execute on delegate or not. | `bool` | `true` | no |
| <a name="input_github_credentials"></a> [github\_credentials](#input\_github\_credentials) | [Optional] (Map) GitHub Connector Credentials. | `map(any)` | `{}` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | [Optional] Provide a Map of Tags to associate with the connector and resources created | `map(any)` | `{}` | no |
| <a name="input_kubernetes_credentials"></a> [kubernetes\_credentials](#input\_kubernetes\_credentials) | [Optional] (Map) Kubernetes Connector Credentials. | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | [Required] Provide a connector name.  Must be two or more characters | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | [Required] Provide an organization reference ID.  Must exist before execution | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | [Required] Provide an project reference ID.  Must exist before execution | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | [Optional] Provide a Map of Tags to associate with the connector | `map(any)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | [Optional] (String) Specifies the Connector type, which is AZURE by default. Can either be azure, us\_government, github or kubernetes | `string` | `"azure"` | no |
| <a name="input_url"></a> [url](#input\_url) | [Required] (String) URL of the Githubhub repository or account. | `string` | `null` | no |
| <a name="input_validation_repo"></a> [validation\_repo](#input\_validation\_repo) | [Optional] (String) Repository to test the connection with. This is only used when connection\_type is Account. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connector_details"></a> [connector\_details](#output\_connector\_details) | n/a |
| <a name="output_success"></a> [success](#output\_success) | n/a |
