provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
}

module "cloudfront" {
  source = "./modules/cloudffront"
  bucket_id = module.s3_bucket.bucket_id
  bucket_arn = module.s3_bucket.bucket_arn
  certificate_arn = module.certificate.certificate_arn
}

module "aws_route53_zone" {
  source = "./modules/route53"
  cloudfront-domain = module.cloudfront.cloudfront-domain-name
  cloudffront-hosted_zone_id = module.cloudfront.cloudffront-hosted_zone_id
}

module "aws_iam_role_policy_attachment" {
  source = "./modules/iam_roles"
}

module "certificate" {
  source = "./modules/certificate"
  aws_route53_zone_id = module.aws_route53_zone.aws_route53_zone_id
}