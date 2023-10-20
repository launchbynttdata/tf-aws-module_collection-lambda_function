# User needs to populate all the fields in <> in order to use this with `terraform plan|apply`
zip_file_path       = "examples/source_from_zip/test_lambda_fn.zip"
vpc_id              = "<vpc_id>"
public_subnets      = ["<subnetid_1>", "<subnetid_2>", "<subnetid_3>"]
zone_id             = "<zone_id>"
zone_name           = "demo.local"
use_https_listeners = true

target_groups = [{
  name        = "https-443-listener"
  target_type = "lambda"
}]

security_group = {
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}
