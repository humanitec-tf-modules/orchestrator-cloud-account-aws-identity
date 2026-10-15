output "iam_role_arn" {
  value       = local.iam_role_arn
  description = "ARN of the IAM role assumed by the Cloud Account"
}
output "iam_role_name" {
  value       = var.iam_role_create ? aws_iam_role.cloud_account_role[0].name : regex("[^/]+$", var.iam_role_arn)
  description = "Name of the IAM role assumed by the Cloud Account"
}
output "cloud_account_id" {
  value       = humanitec_resource_account.aws_identity.id
  description = "ID of the Orchestrator Cloud Account"
}
output "cloud_account_name" {
  value       = humanitec_resource_account.aws_identity.name
  description = "Name of the Orchestrator Cloud Account"
}
output "oidc_provider_arn" {
  value       = local.oidc_provider_arn
  description = "ARN of the OIDC provider. If the ARN of an existing provider was passed in, it is that value, otherwise the ARN of the newly created provider"
}
output "iam_role_trust_policy" {
  value       = data.aws_iam_policy_document.oidc_provider_policy.json
  description = "Trust policy (JSON) allowing the Cloud Account to assume the IAM role. If `iam_role_create` is `false`, apply this policy to the existing role yourself"
}
