resource "aws_key_pair" "openvpnas" {
  key_name   = "openvpnas"
  public_key = file("C:\\Users\\Welceme\\Desktop\\Dev-Practise\\openvpnas.pub")
}

resource "aws_instance" "openvpnas" {
  ami                         = data.aws_ami.openvpn.id
  vpc_security_group_ids      = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id                   = local.public_subnet_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data = file("user-data.sh")

  tags = merge(
    var.common_tags,
    {
      Name = local.bastion_name
    }
  )
}

output "vpn_ip" {
  description = "Display the VPN IP address"
  value       = aws_instance.openvpnas.public_ip
}
