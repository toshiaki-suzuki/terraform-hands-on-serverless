module "dynamodb" {
  source = "../modules/dynamodb"
  prefix = "sample1"
}

module "iam" {
  source = "../modules/iam"
  prefix = "sample1"
  employee_list_table-arn = module.dynamodb.employee_list_table.arn
}

module "lambda" {
  source                = "../modules/lambda"
  prefix                = "sample1"
  employee_list_table-name  = module.dynamodb.employee_list_table.name
  tr_lambda_role-arn        = module.iam.tr_lambda_role-arn
}