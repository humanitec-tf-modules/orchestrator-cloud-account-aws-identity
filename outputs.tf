output "iam_role_arn" {
  value       = aws_iam_role.cloud_account_role.arn
  description = "ARN of the IAM role assumed by the Cloud Account"
}
output "iam_role_name" {
  value       = aws_iam_role.cloud_account_role.name
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
