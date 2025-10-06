output "url" {
  value = aws_elastic_beanstalk_environment.tf_test_env.endpoint_url
}
output "domain" {
    value = aws_elastic_beanstalk_environment.tf_test_env.cname
}