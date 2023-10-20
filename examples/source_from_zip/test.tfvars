zip_file_path = "examples/source_from_zip/test_lambda_fn.zip"

target_groups = [
  {
    name             = "https-443-listener"
    backend_protocol = "HTTPS"
    backend_port     = 443
    target_type      = "ip"
  }
]

security_group = {
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}
