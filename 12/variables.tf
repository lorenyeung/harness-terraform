####################
#
# Harness Structure Default Variables
#
####################
variable "harness_platform_url" {
  type        = string
  description = "[Optional] Enter the Harness Platform URL.  Defaults to Harness SaaS URL"
  default     = "https://app.harness.io/gateway"
}

variable "harness_platform_account" {
  type        = string
  description = "[Required] Enter the Harness Platform Account Number"
  sensitive   = true
}

variable "harness_platform_key" {
  type        = string
  description = "[Required] Enter the Harness Platform API Key for your account"
  sensitive   = true
}

