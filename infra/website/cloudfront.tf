resource "aws_cloudfront_distribution" "cf_dist" {

  enabled             = true
  price_class         = "PriceClass_100"
  aliases             = [var.domain_name]
  is_ipv6_enabled     = true
  default_root_object = "/index.html"

  comment = "Created by Evan"
  tags = {
    "monthly-cs" : "monthly-cs"
    "week" : 1
  }

  origin {
    origin_id                = aws_s3_bucket.bucket.id
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_dist_oac.id
  }

  default_cache_behavior {
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    target_origin_id   = aws_s3_bucket.bucket.id
    trusted_key_groups = null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.acm.arn
    ssl_support_method             = "sni-only"
  }

  custom_error_response {
    error_code            = 400
    response_code         = 400
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }


  custom_error_response {
    error_code            = 403
    response_code         = 403
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }


  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }


  custom_error_response {
    error_code            = 502
    response_code         = 502
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  depends_on = [
    aws_cloudfront_origin_access_control.cf_dist_oac,
    aws_s3_bucket.bucket
  ]
}

