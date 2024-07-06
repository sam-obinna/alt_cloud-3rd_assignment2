resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.primary.id
  name = var.domain_name
  type = "A"

  alias {
    name = var.cloudfront-domain
    zone_id = var.cloudffront-hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.primary.id
  name    = var.domain_name
  type    = "CNAME"
  # alias {
  #    name = var.cloudfront-domain
  #   zone_id = var.cloudffront-hosted_zone_id
  #   evaluate_target_health = false
  # }
  ttl  = 300
  records = [var.cloudfront-domain]
}