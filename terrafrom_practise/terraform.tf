terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }

  backend "s3" {
    bucket         = "bucket-tfstatefile123"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "practise"
  }
}
