resource "aws_cloudfront_distribution" "expense" {
  origin {
    domain_name              = "${var.project_name}-${var.environment}-${var.domain_name}"
    origin_id                = "${var.project_name}-${var.environment}-${var.domain_name}"
  }

  enabled             = true
  aliases = ["${var.project_name}-cdn-${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-${var.environment}-${var.domain_name}"
    
    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.noCache.id 
   
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project_name}-${var.environment}-${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.CacheEnable.id
  }

 # Cache behavior with precedence 1
   ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project_name}-${var.environment}-${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.CacheEnable.id
  }

 

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN"]
    }
  }

  
  viewer_certificate {
    cloudfront_default_certificate = local.https_certificarte_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )
}

resource "aws_route53_record" "cdn" {
  zone_id = var.zone_id
  name    = "expense-${var.environment}${var.domain_name}"
  type    = "A"

  # these are ALB DNS name and zone information
  alias {
    name                   = aws_cloudfront_distribution.expense
    zone_id                = aws_cloudfront_distribution.expense.hosted_zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true 
}