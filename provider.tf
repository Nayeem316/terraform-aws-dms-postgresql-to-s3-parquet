terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }

  # Optional (recommended for real usage): remote backend
  # backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  # No hardcoded profile. Use AWS CLI / SSO / env vars (AWS_PROFILE, etc.)
}
