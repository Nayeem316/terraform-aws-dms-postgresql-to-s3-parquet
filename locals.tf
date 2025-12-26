data "aws_caller_identity" "current" {}

locals {
  created_by = element(
    split("/", data.aws_caller_identity.current.arn),
    length(split("/", data.aws_caller_identity.current.arn)) - 1
  )

  created_on = timestamp() # UTC timestamp

  common_tags = {
    created-by = local.created_by
    created-on = local.created_on
  }

  azs = ["us-east-2a", "us-east-2b"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
}
