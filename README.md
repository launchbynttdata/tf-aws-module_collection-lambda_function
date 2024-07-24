# tf-aws-module_collection-lambda_function

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terrform module creates a Memcached cluster in AWS

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `aws_env.sh` file on local workstation. Developer would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `aws` specific. If primitive/segment under development uses any other cloud provider than AWS, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "aws" {
  profile = "<profile_name>"
  region  = "<region_name>"
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests

# Know Issues
Currently, the `encrypt at transit` is not supported in terraform. There is an open issue for this logged with Hashicorp - https://github.com/hashicorp/terraform-provider-aws/pull/26987

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 5.2.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.17.1 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 8.6.0 |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | terraform-aws-modules/kms/aws | ~> 1.5.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.10.1 |
| <a name="module_dns_record"></a> [dns\_record](#module\_dns\_record) | git::https://github.com/launchbynttdata/tf-aws-module_primitive-dns_record.git | 1.0.0 |
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.3.2 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | terraform-aws-modules/eventbridge/aws | ~> 3.7 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Default security group to be attached | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_zip_file_path"></a> [zip\_file\_path](#input\_zip\_file\_path) | Path of the source zip file with respect to module root | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "acm": {<br>    "max_length": 31,<br>    "name": "acm"<br>  },<br>  "alb": {<br>    "max_length": 31,<br>    "name": "alb"<br>  },<br>  "alb_http_listener": {<br>    "max_length": 60,<br>    "name": "http"<br>  },<br>  "alb_tg": {<br>    "max_length": 31,<br>    "name": "albtg"<br>  },<br>  "eventbridge_role": {<br>    "max_length": 60,<br>    "name": "ebrole"<br>  },<br>  "function": {<br>    "max_length": 60,<br>    "name": "fn"<br>  },<br>  "s3_kms": {<br>    "max_length": 60,<br>    "name": "s3kms"<br>  },<br>  "s3_logs": {<br>    "max_length": 63,<br>    "name": "logs"<br>  },<br>  "security_group": {<br>    "max_length": 60,<br>    "name": "sg"<br>  }<br>}</pre> | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Set false if you do not want to create an ALB with the MQ | `bool` | `true` | no |
| <a name="input_is_internal"></a> [is\_internal](#input\_is\_internal) | Whether this load balancer is internal or public facing | `bool` | `true` | no |
| <a name="input_http_tcp_listeners"></a> [http\_tcp\_listeners](#input\_http\_tcp\_listeners) | Ingress rules to be attached to ECS Service Security Group | <pre>list(object({<br>    port               = number<br>    protocol           = string<br>    target_group_index = number<br>    action_type        = optional(string)<br>    redirect           = optional(map(string))<br>  }))</pre> | <pre>[<br>  {<br>    "action_type": "redirect",<br>    "port": 80,<br>    "protocol": "HTTP",<br>    "redirect": {<br>      "port": "443",<br>      "protocol": "HTTPS",<br>      "status_code": "HTTP_301"<br>    },<br>    "target_group_index": 0<br>  }<br>]</pre> | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of the load balancer. Default is 'application' | `string` | `"application"` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Egress rules to be attached to ECS Service Security Group | <pre>list(object({<br>    name        = string<br>    target_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_use_https_listeners"></a> [use\_https\_listeners](#input\_use\_https\_listeners) | Set true if you want to use HTTPS and a private cert | `bool` | `true` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | Set false if you do not want to create a DNS record for the ALBs | `bool` | `true` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Zone ID of the hosted zone. Conflicts with zone\_name | `string` | `null` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | DNS Hosted zone in this record for this cluster will be created. Required when create\_custom\_dns\_record=true | `string` | `"test10534.demo.local"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the VPC where infrastructure will be provisioned | `string` | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Set false if you do not want to create a security group (no VPC) | `bool` | `true` | no |
| <a name="input_create_package"></a> [create\_package](#input\_create\_package) | Controls whether Lambda package should be created | `bool` | `false` | no |
| <a name="input_create_lambda_function_url"></a> [create\_lambda\_function\_url](#input\_create\_lambda\_function\_url) | Controls whether the Lambda Function URL resource should be created | `bool` | `true` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_kms_s3_key_arn"></a> [kms\_s3\_key\_arn](#input\_kms\_s3\_key\_arn) | ARN of the AWS S3 key used for S3 bucket encryption | `string` | `null` | no |
| <a name="input_kms_s3_key_sse_algorithm"></a> [kms\_s3\_key\_sse\_algorithm](#input\_kms\_s3\_key\_sse\_algorithm) | Server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"aws:kms"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of authentication that the Lambda Function URL uses. Set to 'AWS\_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint. | `string` | `"NONE"` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS settings to be used by the Lambda Function URL | `any` | `{}` | no |
| <a name="input_invoke_mode"></a> [invoke\_mode](#input\_invoke\_mode) | Invoke mode of the Lambda Function URL. Valid values are BUFFERED (default) and RESPONSE\_STREAM. | `string` | `null` | no |
| <a name="input_lambda_at_edge"></a> [lambda\_at\_edge](#input\_lambda\_at\_edge) | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function | `bool` | `false` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | `"index.lambda_handler"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Function runtime | `string` | `"python3.9"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of your Lambda Function | `string` | `""` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments. | `number` | `128` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `512` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `true` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `3` | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails. | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A map that defines environment variables for the Lambda Function. | `map(string)` | `{}` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_attach_dead_letter_policy"></a> [attach\_dead\_letter\_policy](#input\_attach\_dead\_letter\_policy) | Controls whether SNS/SQS dead letter notification policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_network_policy"></a> [attach\_network\_policy](#input\_attach\_network\_policy) | Controls whether VPC/network policy should be added to IAM role for Lambda Function | `bool` | `true` | no |
| <a name="input_attach_policy_json"></a> [attach\_policy\_json](#input\_attach\_policy\_json) | Controls whether policy\_json should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policies"></a> [attach\_policies](#input\_attach\_policies) | Controls whether list of policies should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_number_of_policies"></a> [number\_of\_policies](#input\_number\_of\_policies) | Number of policies to attach to IAM role for Lambda Function | `number` | `0` | no |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | List of additional trusted entities for assuming Lambda Function role (trust relationship) | `any` | `[]` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | An additional policy document as JSON to attach to the Lambda Function role | `string` | `null` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | List of policy statements ARN to attach to Lambda Function role | `list(string)` | `[]` | no |
| <a name="input_s3_prefix"></a> [s3\_prefix](#input\_s3\_prefix) | Directory name where artifacts should be stored in the S3 bucket. If unset, the path from `artifacts_dir` is used | `string` | `null` | no |
| <a name="input_ignore_source_code_hash"></a> [ignore\_source\_code\_hash](#input\_ignore\_source\_code\_hash) | Whether to ignore changes to the function's source code hash. Set to true if you manage infrastructure and code deployments separately. | `bool` | `false` | no |
| <a name="input_s3_existing_package"></a> [s3\_existing\_package](#input\_s3\_existing\_package) | The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use | `map(string)` | `null` | no |
| <a name="input_store_on_s3"></a> [store\_on\_s3](#input\_store\_on\_s3) | Whether to store produced artifacts on S3 or locally. | `bool` | `false` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket to store artifacts | `string` | `null` | no |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | The absolute path to a local file or directory containing your Lambda source code | `any` | `null` | no |
| <a name="input_hash_extra"></a> [hash\_extra](#input\_hash\_extra) | The string to add into hashing function. Useful when building same source path for different functions. | `string` | `""` | no |
| <a name="input_create_schedule"></a> [create\_schedule](#input\_create\_schedule) | Enable scheduling for the lambda to run at a certain frequency. | `bool` | `false` | no |
| <a name="input_lambda_schedule_expression"></a> [lambda\_schedule\_expression](#input\_lambda\_schedule\_expression) | Schedule expression to determine lambda frequency. Supports one-time schedule and recurring schedules, see https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html for specifics. | `string` | `null` | no |
| <a name="input_lambda_schedule_timezone"></a> [lambda\_schedule\_timezone](#input\_lambda\_schedule\_timezone) | IANA Timezone for the schedule expression. Defaults to America/New\_York. | `string` | `"America/New_York"` | no |
| <a name="input_lambda_schedule_payload"></a> [lambda\_schedule\_payload](#input\_lambda\_schedule\_payload) | An optional payload to use when invoking the lambda function through EventBridge | `map(any)` | `{}` | no |
| <a name="input_lambda_layers"></a> [lambda\_layers](#input\_lambda\_layers) | (Optional) List of ARNs of Lambda Layers to include with this function, up to a maximum of 5. | `list(string)` | `null` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | (Optional) Instruction set architecture for your Lambda function. Valid architectures are x86\_64 (default) and arm64. | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_attach_tracing_policy"></a> [attach\_tracing\_policy](#input\_attach\_tracing\_policy) | Controls whether X-Ray tracing policy should be added to the IAM role for this Lambda function. | `bool` | `false` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | (Optional) Tracing mode for your Lambda function. Valid tracing modes are `PassThrough` and `Active`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_lambda_function_arn_static"></a> [lambda\_function\_arn\_static](#output\_lambda\_function\_arn\_static) | The static ARN of the Lambda Function. Use this to avoid cycle errors between resources (e.g., Step Functions) |
| <a name="output_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#output\_lambda\_function\_invoke\_arn) | The Invoke ARN of the Lambda Function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda Function |
| <a name="output_lambda_function_qualified_arn"></a> [lambda\_function\_qualified\_arn](#output\_lambda\_function\_qualified\_arn) | The ARN identifying your Lambda Function Version |
| <a name="output_lambda_function_version"></a> [lambda\_function\_version](#output\_lambda\_function\_version) | Latest published version of Lambda Function |
| <a name="output_lambda_function_last_modified"></a> [lambda\_function\_last\_modified](#output\_lambda\_function\_last\_modified) | The date Lambda Function resource was last modified |
| <a name="output_lambda_function_kms_key_arn"></a> [lambda\_function\_kms\_key\_arn](#output\_lambda\_function\_kms\_key\_arn) | The ARN for the KMS encryption key of Lambda Function |
| <a name="output_lambda_function_source_code_hash"></a> [lambda\_function\_source\_code\_hash](#output\_lambda\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_lambda_function_source_code_size"></a> [lambda\_function\_source\_code\_size](#output\_lambda\_function\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_lambda_function_url"></a> [lambda\_function\_url](#output\_lambda\_function\_url) | The URL of the Lambda Function URL |
| <a name="output_lambda_function_url_id"></a> [lambda\_function\_url\_id](#output\_lambda\_function\_url\_id) | The Lambda Function URL generated id |
| <a name="output_lambda_layer_arn"></a> [lambda\_layer\_arn](#output\_lambda\_layer\_arn) | The ARN of the Lambda Layer with version |
| <a name="output_lambda_layer_layer_arn"></a> [lambda\_layer\_layer\_arn](#output\_lambda\_layer\_layer\_arn) | The ARN of the Lambda Layer without version |
| <a name="output_lambda_layer_created_date"></a> [lambda\_layer\_created\_date](#output\_lambda\_layer\_created\_date) | The date Lambda Layer resource was created |
| <a name="output_lambda_layer_source_code_size"></a> [lambda\_layer\_source\_code\_size](#output\_lambda\_layer\_source\_code\_size) | The size in bytes of the Lambda Layer .zip file |
| <a name="output_lambda_layer_version"></a> [lambda\_layer\_version](#output\_lambda\_layer\_version) | The Lambda Layer version |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | The ARN of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The name of the IAM role created for the Lambda Function |
| <a name="output_lambda_cloudwatch_log_group_arn"></a> [lambda\_cloudwatch\_log\_group\_arn](#output\_lambda\_cloudwatch\_log\_group\_arn) | The ARN of the Cloudwatch Log Group |
| <a name="output_local_filename"></a> [local\_filename](#output\_local\_filename) | The filename of zip archive deployed (if deployment was from local) |
| <a name="output_s3_object"></a> [s3\_object](#output\_s3\_object) | The map with S3 object data of zip archive deployed (if deployment was from S3) |
| <a name="output_record_fqdns"></a> [record\_fqdns](#output\_record\_fqdns) | FQDNs of the Route53 private DNS record(if enabled) |
| <a name="output_record_names"></a> [record\_names](#output\_record\_names) | Record names of the Route53 private DNS record (if enabled) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
