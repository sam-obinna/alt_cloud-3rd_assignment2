variable "bucket_id" {
  description = "The ID of the bucket"
  type        = string
}

variable "bucket_arn" {
  description = "value"
  type = string
}

variable "certificate_arn" {
  description = "arn for acm certifiate"
  type = string
}

variable "domain_name" {
  default = "temitope.i.ng"
}