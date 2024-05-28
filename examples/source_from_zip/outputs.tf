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

output "function_name" {
  value = module.lambda_function.lambda_function_name
}

output "function_arn" {
  value = module.lambda_function.lambda_function_arn
}

output "function_url" {
  value = module.lambda_function.lambda_function_url
}

output "security_group_id" {
  value = module.lambda_function.security_group_ids[0]
}

output "security_group_name" {
  value = module.lambda_function.security_group_names[0]
}

output "security_group_arn" {
  value = module.lambda_function.security_group_arns[0]
}
