terraform {
  required_version = ">= 1.11.0"

  required_providers {
    humanitec = {
      source  = "humanitec/humanitec"
      version = "~> 1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
