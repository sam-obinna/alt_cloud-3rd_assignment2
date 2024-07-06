resource "aws_s3_bucket" "bucket" {
  bucket = "temisbucket123"

  tags = {
    Name = "My bucket"
  }
  force_destroy = true
}

resource "aws_s3_object" "uploads" {
  for_each = fileset("${path.root}/dir_upload", "**/*")

  bucket       = aws_s3_bucket.bucket.bucket
  key          = each.value
  source       = "${"${path.root}/dir_upload"}/${each.value}"
  content_type = "text/html"
}