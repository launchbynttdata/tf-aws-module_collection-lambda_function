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

variable "zip_file_path" {
  description = "Path of the source zip file with respect to module root"
  type        = string
  default     = null
}

### TF Module Resource variables
variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}
variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "us-east-2"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}


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

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    acm = {
      name       = "acm"
      max_length = 31
    }
    alb = {
      name       = "alb"
      max_length = 31
    }
    alb_http_listener = {
      name       = "http"
      max_length = 60
    }
    alb_tg = {
      name       = "albtg"
      max_length = 31
    }
    function = {
      name       = "fn"
      max_length = 60
    }
    s3_kms = {
      name       = "s3kms"
      max_length = 60
    }
    s3_logs = {
      name       = "logs"
      max_length = 63
    }
    security_group = {
      name       = "sg"
      max_length = 60
    }
    eventbridge_role = {
      name       = "ebrole"
      max_length = 60
    }
  }
}

### ALB related variables
variable "create_alb" {
  type        = bool
  default     = true
  description = "Set false if you do not want to create an ALB with the MQ"
}

variable "is_internal" {
  description = "Whether this load balancer is internal or public facing"
  type        = bool
  default     = true
}

variable "http_tcp_listeners" {
  description = "Ingress rules to be attached to ECS Service Security Group"
  type = list(object({
    port               = number
    protocol           = string
    target_group_index = number
    action_type        = optional(string)
    redirect           = optional(map(string))
  }))

  default = [{
    port               = 80
    protocol           = "HTTP"
    target_group_index = 0
    action_type        = "redirect"
    redirect = {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }]
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
  default     = true
  description = "Set true if you want to use HTTPS and a private cert"
}

### DNS
variable "create_dns" {
  type        = bool
  default     = true
  description = "Set false if you do not want to create a DNS record for the ALBs"
}

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
variable "vpc_id" {
  description = "The VPC ID of the VPC where infrastructure will be provisioned"
  type        = string
  default     = null
}

variable "create_package" {
  description = "Controls whether Lambda package should be created"
  type        = bool
  default     = false
}

variable "create_lambda_function_url" {
  description = "Controls whether the Lambda Function URL resource should be created"
  type        = bool
  default     = true
}

### S3 variables
variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "kms_s3_key_arn" {
  type        = string
  default     = null
  description = "ARN of the AWS S3 key used for S3 bucket encryption"
}

variable "kms_s3_key_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "Server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

### Function variables
variable "authorization_type" {
  description = "The type of authentication that the Lambda Function URL uses. Set to 'AWS_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint."
  type        = string
  default     = "NONE"
}

variable "cors" {
  description = "CORS settings to be used by the Lambda Function URL"
  type        = any
  default     = {}
}

variable "invoke_mode" {
  description = "Invoke mode of the Lambda Function URL. Valid values are BUFFERED (default) and RESPONSE_STREAM."
  type        = string
  default     = null
}

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}


variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = "index.lambda_handler"
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "python3.9"
}

variable "description" {
  description = "Description of your Lambda Function"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 512
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = true
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

###########
# Policies
###########

variable "attach_dead_letter_policy" {
  description = "Controls whether SNS/SQS dead letter notification policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "attach_network_policy" {
  description = "Controls whether VPC/network policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = true
}

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "number_of_policies" {
  description = "Number of policies to attach to IAM role for Lambda Function"
  type        = number
  default     = 0
}

variable "trusted_entities" {
  description = "List of additional trusted entities for assuming Lambda Function role (trust relationship)"
  type        = any
  default     = []
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}

variable "policies" {
  description = "List of policy statements ARN to attach to Lambda Function role"
  type        = list(string)
  default     = []
}

##########################
# Build artifact settings
##########################

variable "s3_prefix" {
  description = "Directory name where artifacts should be stored in the S3 bucket. If unset, the path from `artifacts_dir` is used"
  type        = string
  default     = null
}

variable "ignore_source_code_hash" {
  description = "Whether to ignore changes to the function's source code hash. Set to true if you manage infrastructure and code deployments separately."
  type        = bool
  default     = false
}

variable "s3_existing_package" {
  description = "The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use"
  type        = map(string)
  default     = null
}

variable "store_on_s3" {
  description = "Whether to store produced artifacts on S3 or locally."
  type        = bool
  default     = false
}

variable "s3_bucket" {
  description = "S3 bucket to store artifacts"
  type        = string
  default     = null
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code"
  type        = any
  default     = null
}

variable "hash_extra" {
  description = "The string to add into hashing function. Useful when building same source path for different functions."
  type        = string
  default     = ""
}

##########################
# Scheduling settings
##########################

variable "create_schedule" {
  description = "Enable scheduling for the lambda to run at a certain frequency."
  type        = bool
  default     = false
}

variable "lambda_schedule_expression" {
  description = "Schedule expression to determine lambda frequency. Supports one-time schedule and recurring schedules, see https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html for specifics."
  type        = string
  default     = null
}

variable "lambda_schedule_timezone" {
  description = "IANA Timezone for the schedule expression. Defaults to America/New_York."
  type        = string
  default     = "America/New_York"
}

variable "lambda_schedule_payload" {
  description = "An optional payload to use when invoking the lambda function through EventBridge"
  type        = map(any)
  default     = {}
}

variable "lambda_layers" {
  description = "(Optional) List of ARNs of Lambda Layers to include with this function, up to a maximum of 5."
  type        = list(string)
  default     = null
}

variable "architectures" {
  description = "(Optional) Instruction set architecture for your Lambda function. Valid architectures are x86_64 (default) and arm64."
  type        = list(string)
  default     = ["x86_64"]
}

##########################
# Observability settings
##########################

variable "attach_tracing_policy" {
  description = "Controls whether X-Ray tracing policy should be added to the IAM role for this Lambda function."
  type        = bool
  default     = false
}

variable "tracing_mode" {
  description = "(Optional) Tracing mode for your Lambda function. Valid tracing modes are `PassThrough` and `Active`."
  type        = string
  default     = null
}

variable "make_vpc" {
  description = "Controls whether to create a VPC for the Lambda function"
  type        = bool
  default     = false
}
