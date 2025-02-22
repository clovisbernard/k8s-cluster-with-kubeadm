resource "aws_spot_instance_request" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg-master.id]
  spot_price             = "0.03"  # Max price you're willing to pay
  # User data script to set the hostname
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname controlplane
              sudo swapoff -a
              sudo sed -i '/swap/d' /etc/fstab
              EOF
  tags = merge(var.common_tags, {
    Name = "controlplane"
  })
}

resource "aws_spot_instance_request" "node-1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg-node.id]
  spot_price             = "0.03"  # Max price you're willing to pay
  # User data script to set the hostname
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname worker1
              sudo swapoff -a
              sudo sed -i '/swap/d' /etc/fstab
              EOF
  tags = merge(var.common_tags, {
    Name = "worker1"
  })
}

resource "aws_spot_instance_request" "node-2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg-node.id]
  spot_price             = "0.03"  # Max price you're willing to pay
  # User data script to set the hostname
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname worker2
              sudo swapoff -a
              sudo sed -i '/swap/d' /etc/fstab
              EOF
  tags = merge(var.common_tags, {
    Name = "worker2"
  })
}

