resource "aws_s3_bucket" "bucket-tfstatefile" {
  bucket = "${var.env}-${var.bucket_name}terrafrom_modules_by_own"
  tags = {
    name = "${var.env}_terrafrom-bucket"
    environment = var.env
  }

}