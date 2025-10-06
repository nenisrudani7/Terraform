output "url" {
  value = aws_elastic_beanstalk_environment.tf-test-env.endpoint_url
}
output "domain" {
    value = aws_elastic_beanstalk_environment.tf-test-env.cname
}