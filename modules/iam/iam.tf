variable "prefix" {
  type = string
}

variable "employee_list_table-arn" {
  type = string
}

# IAMロールを作成
resource "aws_iam_role" "tr_lambda_role" {
  name = "${var.prefix}_tr_lambda_role"
  assume_role_policy = jsonencode({ # AssumeRoleポリシーをJSON形式で記述
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# IAMロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "tr_lambda_role_policy_attach" {
  role       = aws_iam_role.tr_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDBテーブルへのアクセス権限を付与するインラインポリシーを作成
resource "aws_iam_role_policy" "tr_lambda_role_policy_policy" {
  name = "${var.prefix}_tr_lambda_policy"
  role = aws_iam_role.tr_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem"
        ]
        Resource = [
          var.employee_list_table-arn
        ]
      }
    ]
  })
}

output "tr_lambda_role-arn" {
  value = aws_iam_role.tr_lambda_role.arn
}
