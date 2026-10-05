resource "random_string" "cloud_account_id_suffix" {
  count   = var.cloud_account_id == null ? 1 : 0
  length  = 8
  upper   = false
  special = false
}

locals {
  cloud_account_type = "aws-identity"
  cloud_account_id   = var.cloud_account_id != null ? var.cloud_account_id : "aws-identity-${random_string.cloud_account_id_suffix[0].result}"
  cloud_account_name = var.cloud_account_name != null ? var.cloud_account_name : local.cloud_account_id
  iam_role_name      = var.iam_role_name != null ? var.iam_role_name : "humanitec-${local.cloud_account_id}"
  iam_role_arn       = var.iam_role_create ? aws_iam_role.cloud_account_role[0].arn : var.iam_role_arn
  oidc_provider_arn  = var.oidc_provider_arn != null ? var.oidc_provider_arn : aws_iam_openid_connect_provider.humanitec_oidc[0].arn
}

# OIDC provider for role assumption. Create only if requested
resource "aws_iam_openid_connect_provider" "humanitec_oidc" {
  count = var.oidc_provider_arn == null ? 1 : 0
  url   = "https://idtoken.humanitec.io"
  client_id_list = [
    var.oidc_audience
  ]
}

# Trust policy for the IAM role
data "aws_iam_policy_document" "oidc_provider_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "idtoken.humanitec.io:sub"
      values   = ["${var.humanitec_org_id}/${local.cloud_account_id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "idtoken.humanitec.io:aud"
      values   = [var.oidc_audience]
    }
  }
}

# IAM role to assume. Create only if requested
resource "aws_iam_role" "cloud_account_role" {
  count              = var.iam_role_create ? 1 : 0
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.oidc_provider_policy.json
}

# Orchestrator Cloud Account
resource "humanitec_resource_account" "aws_identity" {
  id   = local.cloud_account_id
  name = local.cloud_account_name
  type = local.cloud_account_type
  credentials = jsonencode(merge(
    { aws_identity_role_arn = local.iam_role_arn },
    var.sts_region != null ? { sts_region = var.sts_region } : {},
    var.oidc_audience != null ? { aws_identity_audience = var.oidc_audience } : {}
  ))
}
