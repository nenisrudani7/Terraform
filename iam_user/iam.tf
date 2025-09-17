# IAM user
resource "aws_iam_user" "iam_user_name" {
  name          = "ec2"
  force_destroy = true

  tags = {
    tag-key = "tag-value"
  }
}

# Programmatic access key

resource "aws_iam_access_key" "credentials" {
  user = aws_iam_user.iam_user_name.name
}


resource "aws_iam_user_login_profile" "credentials" {
  user                    = aws_iam_user.iam_user_name.name
  password_reset_required = false
}

resource "aws_iam_user_policy" "policy" {
  name = "policy"
  user = aws_iam_user.iam_user_name.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        
        Action = [
          "s3:*",
          "ec2:*",
          "iam:ChangePassword",
        ]
        
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


# Optional - caller identity for console sign-in URL
data "aws_caller_identity" "current" {}
# s used to fetch details about the AWS account currently being used.
# It gives you three main things:

# account_id → AWS Account ID

# arn → ARN of the user/role making the call

# user_id → Unique identifier of the user/role