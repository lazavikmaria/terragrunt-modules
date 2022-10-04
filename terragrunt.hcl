
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  common_vars  = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Extract the variables we need for easy access
    account_id   = local.account_vars.locals.aws_account_id
    access_key   = local.account_vars.locals.aws_access_key
    secret_key   = local.account_vars.locals.aws_secret_key
  #  aws_region   = local.region_vars.locals.aws_region
  # environment  = local.common_vars.locals.environment
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region              = var.aws_region
  allowed_account_ids = ["${local.account_id}"]
  access_key          = "${local.access_key}"
  secret_key          = "${local.secret_key}"

  default_tags {
    tags = {
      Product             = var.product
      Environment         = var.environment
    }
   }
  }

variable "access_key" {
  description = "Specifies the current environment."
  type        = string
  default     = "local.access_key"
}
variable "secret_key" {
  description = "Specifies the current environment."
  type        = string
  default     = "local.secret_key"
}

variable "environment" {
  description = "Specifies the current environment."
  type        = string
 # default     = "$${local.environment}"
}

variable "aws_region" {
  description = "Specifies the current environment."
  type        = string
 # default     = "$${local.environment}"
}

variable "product" {
  description = "Specifies the current environment."
  type        = string
 # default     = "$${local.product}"
}
EOF
}
 
# # Configure Terragrunt to automatically store tfstate files in an S3 bucket
# remote_state {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-example-terraform-state-${local.account_name}-${local.aws_region}"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = local.aws_region
#     dynamodb_table = "terraform-locks"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }


# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.common_vars.locals
  
)