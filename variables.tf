variable "humanitec_org_id" {
  type        = string
  description = "Humanitec Organization ID"
  nullable    = false
}
variable "cloud_account_id" {
  type        = string
  description = "ID for the Cloud Account. If not set, the module generates an ID with a random suffix"
  nullable    = true
  default     = null
}
variable "cloud_account_name" {
  type        = string
  description = "Name for the Cloud Account. If not set, will be set to the value of `cloud_account_id`"
  nullable    = true
  default     = null
}
variable "oidc_audience" {
  type        = string
  description = "The OIDC audience for the role policy. If you have registered a custom audience on the IAM OIDC Identity Provider, override the default value of this variable"
  default     = "sts.amazonaws.com"
}
variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the existing OIDC provider for Humanitec. If not set, the module generates one as a convenience but doing so is not recommended for production use as the provider will be bound to this specific Cloud Account lifecycle. The convenience provider uses the value of `oidc_audience` as its client ID list."
  nullable    = true
  default     = null
}
variable "iam_role_create" {
  type        = bool
  description = "Whether to create the IAM role assumed via the Cloud Account. If `false`, `iam_role_name` must be the name of an existing role. The module does not manage the trust policy of an existing role. Use the `iam_role_trust_policy` output to configure it yourself"
  nullable    = false
  default     = true

  validation {
    condition     = var.iam_role_create || var.iam_role_name != null
    error_message = "iam_role_name must be set if iam_role_create is false"
  }
}
variable "iam_role_name" {
  type        = string
  description = "The name for the IAM role assumed via the Cloud Account. If `iam_role_create` is `true` and this is not set, the module generates a name including the cloud account id. If `iam_role_create` is `false`, the name of the existing role"
  nullable    = true
  default     = null
}
variable "sts_region" {
  type        = string
  description = "Humanitec uses the regional STS endpoint `sts.us-east-1.amazonaws.com` by default. To use the endpoint in a different region, set this variable"
  nullable    = true
  default     = null
}
