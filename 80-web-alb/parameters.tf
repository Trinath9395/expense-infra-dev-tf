resource "aws_ssm_parameter" "web_alb_listner_arn" {
  type = "String"
  name = "/${var.project_name}/${var.environment}/web_alb_listner_arn"
  value = aws_alb_listener.https.arn 
}