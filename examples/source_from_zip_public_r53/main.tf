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

module "lambda_function" {
  source = "../.."

  # Variables
  is_internal         = var.is_internal
  load_balancer_type  = var.load_balancer_type
  security_group      = var.security_group
  target_groups       = var.target_groups
  use_https_listeners = var.use_https_listeners
  vpc_subnet_ids      = var.public_subnets
  vpc_id              = var.vpc_id
  zip_file_path       = var.zip_file_path
  zone_id             = var.zone_id
  zone_name           = var.zone_name

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service

  tags = var.tags
}
