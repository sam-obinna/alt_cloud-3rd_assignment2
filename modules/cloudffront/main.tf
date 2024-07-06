resource "aws_s3_bucket" "temisbucket123" {
  bucket = "temisbucket123"

  tags = {
    Name = "My bucket"
  }
  force_destroy = true
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for temisbucket123"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.temisbucket123.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${var.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = aws_s3_bucket.temisbucket123.bucket_regional_domain_name
    origin_id   = "S3-temisbucket123"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for temisbucket123"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "S3-temisbucket123"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv.2_2021"
  }

aliases = [ var.domain_name ]
}
