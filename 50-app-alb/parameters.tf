resource "aws_ssm_parameter" "app_alb_listner_arn" {
  name = "/${var.project_name}/${var.environment}/app_alb_listner_arn"
  type = "String"
  value = app_alb_listner.http_arn
}