<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.1.2 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.10.1 |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.zip_file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for the VPC | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b",<br>  "us-east-2c"<br>]</pre> | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | `"index.lambda_handler"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet cidrs | `list(string)` | <pre>[<br>  "10.1.1.0/24",<br>  "10.1.2.0/24",<br>  "10.1.3.0/24"<br>]</pre> | no |
| <a name="input_s3_source_key"></a> [s3\_source\_key](#input\_s3\_source\_key) | S3 object key of the source | `string` | n/a | yes |
| <a name="input_s3_source_path"></a> [s3\_source\_path](#input\_s3\_source\_path) | Local source path of the zip to upload | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.1.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The Name of the VPC | `string` | `"lambda-test-vpc"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
