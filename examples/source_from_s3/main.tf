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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  azs                  = var.availability_zones
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  name                 = var.vpc_name
  private_subnets      = var.private_subnets

  tags = var.tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.10.1"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_object" "zip_file" {
  bucket     = module.s3_bucket.s3_bucket_id
  key        = var.s3_source_key
  source     = "${var.s3_source_path}/${var.s3_source_key}"
  depends_on = [module.s3_bucket]
}

module "lambda_function" {
  source = "../.."

  # Variables
  handler        = local.handler
  vpc_subnet_ids = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id
  store_on_s3    = true
  s3_existing_package = {
    bucket = module.s3_bucket.s3_bucket_id
    key    = var.s3_source_key
  }

  create_alb = false
  create_dns = false
  make_vpc   = true

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service

  tags = var.tags
}
