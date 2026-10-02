# All providers are mocked so runs can use "command = apply" without real credentials.
# This makes values only known after apply (like the random suffix) available to assertions.
# These runs live in their own file because each test file has its own state, so the
# mocked resources never get refreshed by the real providers used in other test files.

mock_provider "aws" {
  # aws_iam_role validates that the trust policy is a JSON object
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }
}

mock_provider "humanitec" {}

mock_provider "random" {
  mock_resource "random_string" {
    defaults = {
      result = "abcd1234"
    }
  }
}

run "test_all_default" {
  command = apply

  variables {
    humanitec_org_id = "my-org"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.humanitec_oidc) == 1
    error_message = "The module must create an OIDC provider if oidc_provider_arn is not set"
  }

  assert {
    condition     = humanitec_resource_account.aws_identity.id == "aws-identity-abcd1234"
    error_message = "The Cloud Account ID must default to 'aws-identity-' plus a random suffix"
  }

  assert {
    condition     = humanitec_resource_account.aws_identity.name == humanitec_resource_account.aws_identity.id
    error_message = "The Cloud Account name must default to the Cloud Account ID"
  }

  assert {
    condition     = aws_iam_role.cloud_account_role.name == "humanitec-aws-identity-abcd1234"
    error_message = "The IAM role name must default to 'humanitec-' plus the Cloud Account ID"
  }
}

run "test_custom_oidc_audience" {
  command = apply

  variables {
    humanitec_org_id = "my-org"
    oidc_audience    = "my-custom-audience"
  }

  assert {
    condition     = jsondecode(humanitec_resource_account.aws_identity.credentials).aws_identity_audience == var.oidc_audience
    error_message = "The Cloud Account credentials must contain oidc_audience as aws_identity_audience"
  }

  assert {
    condition     = jsondecode(humanitec_resource_account.aws_identity.credentials).aws_identity_role_arn == aws_iam_role.cloud_account_role.arn
    error_message = "The Cloud Account credentials must contain the ARN of the IAM role"
  }
}
