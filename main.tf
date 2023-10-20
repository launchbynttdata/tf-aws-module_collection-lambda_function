// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Module to generate the AWS resource names
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.2.0"

  # Base variables
  function_name  = module.resource_names["function"].standard
  description    = var.description
  handler        = var.handler
  runtime        = var.runtime
  publish        = var.publish
  create_package = var.create_package

  # S3 Source
  s3_existing_package = var.create_package ? null : var.s3_existing_package

  # Local Source
  source_path            = var.create_package ? var.source_path : null
  local_existing_package = var.zip_file_path != null && var.store_on_s3 == false ? "${var.zip_file_path}" : null

  # Store On S3
  s3_bucket = var.store_on_s3 ? var.s3_bucket : null
  s3_prefix = var.store_on_s3 ? var.s3_prefix : null


  # URL Variables
  authorization_type         = var.authorization_type
  cors                       = var.cors
  create_lambda_function_url = var.create_lambda_function_url
  invoke_mode                = var.invoke_mode

  # Other variables
  attach_dead_letter_policy = var.attach_dead_letter_policy
  attach_network_policy     = var.attach_network_policy
  attach_policies           = var.attach_policies
  attach_policy_json        = var.attach_policy_json
  dead_letter_target_arn    = var.dead_letter_target_arn
  ephemeral_storage_size    = var.ephemeral_storage_size
  environment_variables     = var.environment_variables
  hash_extra                = var.hash_extra
  ignore_source_code_hash   = var.ignore_source_code_hash
  lambda_at_edge            = var.lambda_at_edge
  memory_size               = var.memory_size
  number_of_policies        = var.number_of_policies
  policies                  = var.policies
  policy_json               = var.policy_json
  timeout                   = var.timeout
  trusted_entities          = var.trusted_entities

  allowed_triggers = local.allowed_triggers

  vpc_security_group_ids = var.vpc_id != null ? [module.security_group[0].security_group_id] : []
  vpc_subnet_ids         = var.vpc_subnet_ids

  tags = merge(var.tags, { resource_name = module.resource_names["function"].standard })
}

module "resource_names" {
  source = "git::https://github.com/nexient-llc/tf-module-resource_name.git?ref=0.1.0"

  for_each = var.resource_names_map

  logical_product_name = var.naming_prefix
  region               = join("", split("-", var.region))
  class_env            = var.environment
  cloud_resource_type  = each.value.name
  instance_env         = var.environment_number
  instance_resource    = var.resource_number
  maximum_length       = each.value.max_length
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.1"
  count   = var.vpc_id != null ? 1 : 0

  vpc_id                   = var.vpc_id
  name                     = module.resource_names["security_group"].standard
  description              = "Security Group for Lambda functions"
  ingress_cidr_blocks      = coalesce(try(lookup(var.security_group, "ingress_cidr_blocks", []), []), [])
  ingress_rules            = coalesce(try(lookup(var.security_group, "ingress_rules", []), []), [])
  ingress_with_cidr_blocks = coalesce(try(lookup(var.security_group, "ingress_with_cidr_blocks", []), []), [])
  egress_cidr_blocks       = coalesce(try(lookup(var.security_group, "egress_cidr_blocks", []), []), [])
  egress_rules             = coalesce(try(lookup(var.security_group, "egress_rules", []), []), [])
  egress_with_cidr_blocks  = coalesce(try(lookup(var.security_group, "egress_with_cidr_blocks", []), []), [])

  tags = merge(var.tags, { resource_name = module.resource_names["security_group"].standard })
}

module "alb" {
  source    = "terraform-aws-modules/alb/aws"
  version   = "~> 8.6.0"
  count     = var.create_alb ? 1 : 0
  create_lb = var.create_alb

  # ALB configuration
  name                  = module.resource_names["alb"].recommended_per_length_restriction
  create_security_group = false
  internal              = var.is_internal
  load_balancer_type    = var.load_balancer_type
  security_groups       = [module.security_group[0].security_group_id]
  subnets               = var.vpc_subnet_ids
  vpc_id                = var.vpc_id

  # Target group configuration
  target_groups = local.target_groups


  # Listener configuration
  http_tcp_listeners = var.http_tcp_listeners
  https_listeners = var.use_https_listeners ? [{
    port               = 443
    protocol           = "HTTPS"
    target_group_index = 0
    certificate_arn    = module.acm[0].acm_certificate_arn
  }] : []

  access_logs = {
    bucket = module.s3_bucket[0].s3_bucket_id
    # This is required for this issue https://github.com/hashicorp/terraform-provider-aws/issues/16674
    enabled = true
  }

  # Tags
  http_tcp_listeners_tags = merge(local.tags, { Id = module.resource_names["alb_http_listener"].standard })
  tags                    = merge(local.tags, { resource_name = module.resource_names["alb"].standard })

  depends_on = [module.s3_bucket]
}

module "kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5.0"

  aliases     = [module.resource_names["s3_kms"].standard]
  description = "KMS Key used to encrypt the S3 buckets used for the ELB logs."

  tags = merge(local.tags, { resource_name = "s3_kms" })
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.10.1"

  count = var.create_alb ? 1 : 0

  bucket = module.resource_names["s3_logs"].recommended_per_length_restriction

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # Allow deletion of non-empty bucket
  force_destroy = true

  # Server-side encryption configuration
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = var.kms_s3_key_sse_algorithm
        kms_master_key_id = var.kms_s3_key_arn
      }
    }
  }

  # Required for ALB logs
  attach_elb_log_delivery_policy = true

  tags = merge(local.tags, { resource_name = module.resource_names["s3_logs"].standard })
}

module "dns_record" {
  source = "git::https://github.com/nexient-llc/tf-aws-wrapper_module-dns_record.git?ref=0.1.0"

  count = var.create_dns ? 1 : 0

  zone_id      = var.zone_id
  private_zone = false
  records = [{
    name = module.resource_names["function"].standard
    type = "A"
    alias = {
      name    = module.alb[0].lb_dns_name
      zone_id = module.alb[0].lb_zone_id
    }
  }]
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3.2"

  count = var.create_dns ? 1 : 0

  domain_name = local.domainfqn
  zone_id     = var.zone_id

  tags = merge(local.tags, { resource_name = module.resource_names["acm"].standard })
}

module "eventbridge" {
  source     = "terraform-aws-modules/eventbridge/aws"
  count      = var.create_schedule ? 1 : 0
  create_bus = false

  role_name            = module.resource_names["eventbridge_role"].standard
  attach_lambda_policy = true
  lambda_target_arns   = [module.lambda_function.lambda_function_arn]
  rules = {
    "${module.lambda_function.lambda_function_name}_cron" = {
      description         = "Trigger for Lambda ${module.lambda_function.lambda_function_name}"
      schedule_expression = var.lambda_schedule_expression
      timezone            = var.lambda_schedule_timezone
    }
  }

  targets = {
    "${module.lambda_function.lambda_function_name}_cron" = [
      {
        name  = module.lambda_function.lambda_function_name
        arn   = module.lambda_function.lambda_function_arn
        input = jsonencode(var.lambda_schedule_payload)
      }
    ]
  }
}
