 resource "aws_instance" "backend" {
    ami = data.aws_ami.joindevops.id
    vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
    subnet_id = local.private_subnet_id
    instance_type = "t2.micro" 

   tags = merge(
    var.common_tags,
    {
        Name = local.backend_name
    }
   )
}

resource "null_resource" "backend" {
  triggers = {
    instance_id = aws_instance.backend.id 
  }

  connection {
    host = aws_instance.backend.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/backend.sh",
        "sudo sh /tmp/backend ${var.environment}"
     ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = aws_instance.backend.id 
  state = "stopped"
  depends_on = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = local.backend_name
  source_instance_id = aws_instance.backend.id 
  depends_on = [aws_ec2_instance_state.backend]
}

resource "null_resource" "backend" {
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }

  depends_on = [aws_ami_from_instance.backend]
}
