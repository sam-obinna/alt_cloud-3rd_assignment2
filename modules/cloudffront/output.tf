output "cloudfront-domain-name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "cloudffront-hosted_zone_id" {
  value = aws_cloudfront_distribution.cloudfront.hosted_zone_id
}

output "aws_cloudfront_origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}