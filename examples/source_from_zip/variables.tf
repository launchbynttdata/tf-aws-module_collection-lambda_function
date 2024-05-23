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

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "private_subnets" {
  description = "List of public subnet cidrs"
  type        = list(string)
  default     = ["10.5.1.0/24", "10.5.2.0/24", "10.5.3.0/24"]
}

variable "security_group" {
  description = "Default security group to be attached"
  type = object({
    ingress_rules            = optional(list(string))
    ingress_cidr_blocks      = optional(list(string))
    ingress_with_cidr_blocks = optional(list(map(string)))
    egress_rules             = optional(list(string))
    egress_cidr_blocks       = optional(list(string))
    egress_with_cidr_blocks  = optional(list(map(string)))
  })

  default = null
}

### ALB related variables
variable "target_groups" {
  description = "Egress rules to be attached to ECS Service Security Group"
  type = list(object({
    name             = string
    backend_protocol = string
    backend_port     = number
    target_type      = string
  }))

  default = []
}

### VPC related variables
variable "vpc_cidr" {
  type    = string
  default = "10.5.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "The Name of the VPC"
  default     = "lambda-test-vpc"
}

variable "zip_file_path" {
  description = "Path of the source zip file with respect to module root"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

### TF Module Resource variables
variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}
