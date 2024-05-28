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

variable "public_subnets" {
  description = "List of public subnet cidrs"
  type        = list(string)
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

variable "vpc_id" {
  description = "The VPC ID of the VPC where infrastructure will be provisioned"
  type        = string
  default     = null
}

### DNS related variables
variable "zone_id" {
  description = "Zone ID of the hosted zone. Conflicts with zone_name"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "DNS Hosted zone in this record for this cluster will be created. Required when create_custom_dns_record=true"
  type        = string
  default     = "test10534.demo.local"
}

### VPC related variables
variable "zip_file_path" {
  description = "Path of the source zip file with respect to module root"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

### ALB related variables
variable "is_internal" {
  description = "Whether this load balancer is internal or public facing"
  type        = bool
  default     = true
}

variable "load_balancer_type" {
  description = "The type of the load balancer. Default is 'application'"
  type        = string
  default     = "application"
}

variable "target_groups" {
  description = "Egress rules to be attached to ECS Service Security Group"
  type = list(object({
    name        = string
    target_type = string
  }))

  default = []
}

variable "use_https_listeners" {
  type        = bool
  default     = false
  description = "Set true if you want to use HTTPS and a private cert"
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
