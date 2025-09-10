 resource "aws_instance" "openvpn" {
    ami = data.aws_ami.openvpn.id
    vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
    subnet_id = local.public_subnet_id
    instance_type = "t2.micro" 

   tags = merge(
    var.common_tags,
    {
        Name = local.bastion_name
    }
   )
}
