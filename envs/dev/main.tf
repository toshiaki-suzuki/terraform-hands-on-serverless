module "dynamodb" {
  source = "../../modules/dynamodb"
  prefix = var.prefix
}

module "iam" {
  source = "../../modules/iam"
  prefix = var.prefix
  employee_list_table-arn = module.dynamodb.employee_list_table.arn
}

module "lambda" {
  source = "../../modules/lambda"
  prefix = var.prefix
  employee_list_table-name = module.dynamodb.employee_list_table.name
  tr_lambda_role-arn = module.iam.tr_lambda_role-arn
  tr_api-execution-arn = module.api_gateway.tr_api-execution-arn
}

module "api_gateway" {
  source = "../../modules/api-gateway"
  prefix = var.prefix
  tr_lambda-invoke-arn = module.lambda.tr_lambda-invoke-arn
}