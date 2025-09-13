data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CacheEnable" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "https_certificarte_arn" {
    name = "/${var.project_name}/${var.environment}/web_alb_certification_arn"
}
