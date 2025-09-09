module "mysql_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "instaces for mysql"
  sg_name = "mysql"
  project_name = var.project_name
  environment = var.environment
}

module "backend_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "backend instances"
  sg_name = "backend"
  project_name = "expense"
  environment = "dev"
}

module "frontend_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "frontend instances"
  sg_name = "frontend"
  project_name = "expense"
  environment = "dev"
}

module "bastion_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "bastion instances"
  sg_name = "bastion"
  project_name = "expense"
  environment = "dev"
}

module "app_alb_sg" {
   source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "Created for backend ALB instances"
  sg_name = "app-alb"
  project_name = "expense"
  environment = "dev"
}