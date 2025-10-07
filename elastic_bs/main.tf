
###############################
# IAM ROLE
###############################

resource "aws_iam_role" "role-elb" {
  name = "role-elb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

###############################
# IAM INSTANCE PROFILE
###############################

resource "aws_iam_instance_profile" "tf-ellb" {
  name = "awselasticbeanstalk-ec2-role"
  role = aws_iam_role.role-elb.name
}

    resource "aws_s3_bucket" "app_source_bucket" {
      bucket = "s3-for-ebs-zip-file" # Replace with your desired bucket name
      acl    = "private" # Or other appropriate ACL
    }

    resource "aws_s3_object" "app_source_bundle" {
      bucket = aws_s3_bucket.app_source_bucket.id
      key    = "index.zip" # Or a dynamic key using uuid()
      source = var.app_zip_path # Path to your local ZIP file
    }

# ELASTIC BEANSTALK APPLICATION


resource "aws_elastic_beanstalk_application" "tf_test" {
  name        = "test-app"
  description = "Testing tf-elb"
}
 resource "aws_elastic_beanstalk_application_version" "my_app_version" {
      application = aws_elastic_beanstalk_application.tf_test.name
      name        = "v1.0.0"
      bucket      = aws_s3_bucket.app_source_bucket.id
      key         = aws_s3_object.app_source_bundle.key
    }

# ELASTIC BEANSTALK ENVIRONMENT

resource "aws_elastic_beanstalk_environment" "tf_test_env" {
  name                = "test-env"
  application         = aws_elastic_beanstalk_application.tf_test.name
  solution_stack_name = var.solution_stack_name
  version_label       = aws_elastic_beanstalk_application_version.my_app_version.name
  tier                = "WebServer"

for_each = [ "value" ]
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.tf-ellb.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCID"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet)
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
}


