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
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet cidrs | `list(string)` | n/a | yes |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Default security group to be attached | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the VPC where infrastructure will be provisioned | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Zone ID of the hosted zone. Conflicts with zone\_name | `string` | `null` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | DNS Hosted zone in this record for this cluster will be created. Required when create\_custom\_dns\_record=true | `string` | `"test10534.demo.local"` | no |
| <a name="input_zip_file_path"></a> [zip\_file\_path](#input\_zip\_file\_path) | Path of the source zip file with respect to module root | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_internal"></a> [is\_internal](#input\_is\_internal) | Whether this load balancer is internal or public facing | `bool` | `true` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of the load balancer. Default is 'application' | `string` | `"application"` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Egress rules to be attached to ECS Service Security Group | <pre>list(object({<br>    name        = string<br>    target_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_use_https_listeners"></a> [use\_https\_listeners](#input\_use\_https\_listeners) | Set true if you want to use HTTPS and a private cert | `bool` | `false` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
