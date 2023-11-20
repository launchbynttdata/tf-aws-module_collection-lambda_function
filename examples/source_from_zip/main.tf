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

module "lambda_function" {
  source = "../.."

  # Variables
  security_group = var.security_group
  target_groups  = var.target_groups
  vpc_subnet_ids = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id
  zip_file_path  = var.zip_file_path

  create_alb = false
  create_dns = false

  tags = var.tags
}
