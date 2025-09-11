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
  project_name = var.project_name
  environment = var.environment
}

module "frontend_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "frontend instances"
  sg_name = "frontend"
  project_name = var.project_name
  environment = var.environment
}

module "bastion_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "bastion instances"
  sg_name = "bastion"
  project_name = var.project_name
  environment = var.environment
}

module "vpn_sg" {
  source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "VPN access for dev teams"
  sg_name = "vpn"
  project_name = var.project_name
  environment = var.environment
}

module "app_alb_sg" {
   source = "git::https://github.com/Trinath9395/terraform-aws-sgroup.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_description = "Created for backend ALB instances"
  sg_name = "app-alb"
  project_name = var.project_name
  environment = var.environment
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id 
}

resource "aws_security_group_rule" "vpn_ssh" {
  type = "ingress"
  from_port = 22 
  to_port = 22 
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_443" {
  type = "ingress"
  from_port = 443
  to_port = 443 
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id 
}

resource "aws_security_group_rule" "vpn_943" {
  type = "ingress"
  from_port = 943
  to_port = 943
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type = "ingress"
  from_port = 1194
  to_port = 1194
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id 
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id 
  security_group_id = module.app_alb_sg.sg_id 
}

resource "aws_security_group_rule" "mysql_bastion" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id 
  security_group_id = module.mysql_sg.sg_id  
}

resource "aws_security_group_rule" "mysql_vpn" {
  type = "ingress"
  from_port = 3306
  to_port = 3306 
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id 
  security_group_id = module.mysql_sg.sg_id 
}

resource "aws_security_group_rule" "backend_vpn" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id 
  security_group_id = module.backend_sg.sg_id 
}

resource "aws_security_group_rule" "mysql_backend" {
  type = "ingress"
  from_port = 3306
  to_port =   3306
  protocol = "tcp"
  source_security_group_id = module.backend_sg.sg_id 
  security_group_id = module.mysql_sg.sg_id 
}