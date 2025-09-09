module "alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true
  name    = "${var.project_name}-${var.environment}-app-alb"
  vpc_id  = data.aws_ssm_parameter.vpc_id.value
  subnets = local.private_subnet_ids
  create_security_group = false
  security_groups = [local.app_alb_sg_id]

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port = "80"
  protocol = "http"

  default_action {
    type = "fixed-responce"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from backend APP ALB</h1>"
      status_code = "200"
    }
  }
  
    

}