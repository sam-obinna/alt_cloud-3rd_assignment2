variable "domain_name" {
  default = "temitope.i.ng"
}

variable "cloudfront-domain" {
  description = "clloudfront front domain that route 53 will point to" 
  type = string
}

variable "cloudffront-hosted_zone_id" {
  description = "cloudfront hosted zone id"
  type = string
}