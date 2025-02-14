module "cloudfront_custom_origin" {
  source                         = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudfront_custom_origin//?ref=v0.12.0"
  comment                        = "CloudFront Distribution for Production Environment"
  allowed_methods                = ["GET", "HEAD"]
  cached_methods                 = ["GET", "HEAD"]
  default_root_object            = "index.html"
  default_ttl                    = "86400"
  domain_name                    = data.terraform_remote_state.compute_layer.outputs.alb_dns_name
  enabled                        = true
  environment                    = "Production"
  origin_id                      = random_string.cloudfront_rstring.result
  price_class                    = "PriceClass_All"
  query_string                   = false
  target_origin_id               = random_string.cloudfront_rstring.result
  custom_header                  =  [{name = "TK_Origin", value = "3DN3eKUEEbHZ4qyT"}]
  tags                           = local.tags
  ssl_support_method             = "sni-only"
  locations                      = ["US", "CA", "GB", "DE"]
  min_ttl                        = "1"
  max_ttl                        = "315360000"
  origin_protocol_policy         = "http-only"
  viewer_protocol_policy         = "redirect-to-https"
  restriction_type               = "whitelist"
  path_pattern                   = "*"
  forward                        = "none"
  minimum_protocol_version       = "TLSv1"
  cloudfront_default_certificate = false
  acm_certificate_arn            = var.certificate_arn
}

resource "random_string" "cloudfront_rstring" {
  length  = 18
  special = false
  upper   = false
}