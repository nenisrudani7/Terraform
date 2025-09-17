output "iam_user_name" {
  value = aws_iam_user.iam_user_name.name
  description = "IAM username"
  sensitive = false
}

output "iam_user_arn" {
  value = aws_iam_user.iam_user_name.arn
  description = "IAM user ARN"
  sensitive = false
}

output "password" {
  value     = aws_iam_user_login_profile.credentials.password
  sensitive = true
}

output "secret" {
  value     = aws_iam_access_key.credentials.secret
  sensitive = true
}


output "access_key" {
  value = aws_iam_access_key.credentials.id
}

output "console_login_url" {
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  description = "Account-specific AWS console signin URL"
  sensitive   = false
}








# --------------------------------------------------------------------------------------------------

# output "iam_user_name" {
#   value = aws_iam_user.lb.name
# }

# output "iam_user_arn" {
#   value = aws_iam_user.lb.arn
# }

# output "iam_access_key_id" {
#   value = aws_iam_access_key.lb.id
#   sensitive = false
# }

# output "iam_secret_access_key" {
#   value     = aws_iam_access_key.lb.secret
#   sensitive = false #if false then it shows you sensitive in output can't show real values 
# }

# output "console_password" {
#   value = random_password.pw.result
#   sensitive = false
# }

# output "console_login_url" {
#   value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
# }
