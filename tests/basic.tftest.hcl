# See https://developer.hashicorp.com/terraform/language/tests for more on how to write tests.
# See https://developer.hashicorp.com/terraform/language/tests/mocking for information on mocking providers.

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

# Mocked so the tests need no Humanitec API token
mock_provider "humanitec" {}

run "test_existing_oidc_provider" {
  command = plan

  variables {
    humanitec_org_id  = "my-org"
    cloud_account_id  = "my-cloud-account"
    oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/idtoken.humanitec.io"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.humanitec_oidc) == 0
    error_message = "The module must not create an OIDC provider if oidc_provider_arn is set"
  }

  assert {
    condition     = output.oidc_provider_arn == var.oidc_provider_arn
    error_message = "The oidc_provider_arn output must equal the oidc_provider_arn variable"
  }

  assert {
    condition     = jsondecode(data.aws_iam_policy_document.oidc_provider_policy.json).Statement[0].Principal.Federated == var.oidc_provider_arn
    error_message = "The IAM role trust policy must reference the existing OIDC provider"
  }
}
# Values depending on oidc_audience are spread over several runs because they are known at plan
# time under different conditions. The Cloud Account credentials are tested in defaults.tftest.hcl
run "test_custom_oidc_audience_new_oidc_provider" {
  command = plan

  variables {
    humanitec_org_id = "my-org"
    oidc_audience    = "my-custom-audience"
  }

  assert {
    condition     = aws_iam_openid_connect_provider.humanitec_oidc[0].client_id_list == toset([var.oidc_audience])
    error_message = "The OIDC provider must use oidc_audience as its client ID list"
  }
}

run "test_custom_oidc_audience_existing_oidc_provider" {
  command = plan

  variables {
    humanitec_org_id  = "my-org"
    cloud_account_id  = "my-cloud-account"
    oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/idtoken.humanitec.io"
    oidc_audience     = "my-custom-audience"
  }

  assert {
    condition     = jsondecode(data.aws_iam_policy_document.oidc_provider_policy.json).Statement[0].Condition.StringEquals["idtoken.humanitec.io:aud"] == var.oidc_audience
    error_message = "The IAM role trust policy must require oidc_audience as the token audience"
  }
}

run "test_existing_iam_role_requires_name" {
  command = plan

  variables {
    humanitec_org_id = "my-org"
    iam_role_create  = false
  }

  expect_failures = [
    var.iam_role_create,
  ]
}
