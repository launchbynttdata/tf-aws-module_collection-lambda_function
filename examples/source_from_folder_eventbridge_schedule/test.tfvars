create_package             = true
source_path                = "test_lambda_fn"
create_schedule            = true
lambda_schedule_expression = "rate(5 minutes)"
logical_product_family     = "terratest"
logical_product_service    = "lambda"
