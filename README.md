> [!NOTE]
> 🚧 The content of this repository is currently being curated. Please do not use before the first release has been cut.

# Cloud Accounts

This repository contains a OpenTofu/Terraform module for managing Cloud Accounts of type [AWS Role Assumption with Web Identity](https://developer.humanitec.com/platform-orchestrator/docs/platform-orchestrator/security/cloud-accounts/overview/) in the [Humanitec Platform Orchestrator](https://developer.humanitec.com/platform-orchestrator/).

## Usage

TODO - add usage examples

- Include using your own role and setting the trust policy:

```hcl
resource "aws_iam_role" "mine" {
  name               = "my-own-role"
  assume_role_policy = module.cloud_account.iam_role_trust_policy
}

module "cloud_account" {
  # ...
  iam_role_create = false
  iam_role_arn    = aws_iam_role.mine.arn
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_humanitec"></a> [humanitec](#requirement\_humanitec) | ~> 1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.humanitec_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cloud_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [humanitec_resource_account.aws_identity](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_account) | resource |
| [random_string.cloud_account_id_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.oidc_provider_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_account_id"></a> [cloud\_account\_id](#input\_cloud\_account\_id) | ID for the Cloud Account. If not set, the module generates an ID with a random suffix | `string` | `null` | no |
| <a name="input_cloud_account_name"></a> [cloud\_account\_name](#input\_cloud\_account\_name) | Name for the Cloud Account. If not set, will be set to the value of `cloud_account_id` | `string` | `null` | no |
| <a name="input_humanitec_org_id"></a> [humanitec\_org\_id](#input\_humanitec\_org\_id) | Humanitec Organization ID | `string` | n/a | yes |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The ARN of an existing IAM role assumed via the Cloud Account. Required if `iam_role_create` is `false`, must not be set otherwise | `string` | `null` | no |
| <a name="input_iam_role_create"></a> [iam\_role\_create](#input\_iam\_role\_create) | Whether to create the IAM role assumed via the Cloud Account. If `false`, `iam_role_arn` must be the ARN of an existing role. The module does not manage the trust policy of an existing role. Use the `iam_role_trust_policy` output to configure it yourself | `bool` | `true` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name for the IAM role created by the module. If not set, the module generates a name including the cloud account id. Only used if `iam_role_create` is `true` | `string` | `null` | no |
| <a name="input_oidc_audience"></a> [oidc\_audience](#input\_oidc\_audience) | The OIDC audience for the role policy. If you have registered a custom audience on the IAM OIDC Identity Provider, override the default value of this variable | `string` | `"sts.amazonaws.com"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | ARN of the existing OIDC provider for Humanitec. If not set, the module generates one as a convenience but doing so is not recommended for production use as the provider will be bound to this specific Cloud Account lifecycle. The convenience provider uses the value of `oidc_audience` as its client ID list. | `string` | `null` | no |
| <a name="input_sts_region"></a> [sts\_region](#input\_sts\_region) | Humanitec uses the regional STS endpoint `sts.us-east-1.amazonaws.com` by default. To use the endpoint in a different region, set this variable | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_account_id"></a> [cloud\_account\_id](#output\_cloud\_account\_id) | ID of the Orchestrator Cloud Account |
| <a name="output_cloud_account_name"></a> [cloud\_account\_name](#output\_cloud\_account\_name) | Name of the Orchestrator Cloud Account |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role assumed by the Cloud Account |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role assumed by the Cloud Account |
| <a name="output_iam_role_trust_policy"></a> [iam\_role\_trust\_policy](#output\_iam\_role\_trust\_policy) | Trust policy (JSON) allowing the Cloud Account to assume the IAM role. If `iam_role_create` is `false`, apply this policy to the existing role yourself |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the OIDC provider. If the ARN of an existing provider was passed in, it is that value, otherwise the ARN of the newly created provider |
<!-- END_TF_DOCS -->
