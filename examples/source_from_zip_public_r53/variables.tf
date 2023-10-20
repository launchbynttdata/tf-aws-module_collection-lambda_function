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
  default     = ""
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
variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  default     = "000"
}

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "platform"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  default     = "000"
}
