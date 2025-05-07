resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.daryn.instance_type
  key_name                    = var.daryn.key_name
  subnet_id                   = var.daryn.subnet_id
  vpc_security_group_ids      = [aws_security_group.sg-control-plane.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                set -xe
                hostnamectl set-hostname controlplane
                echo "127.0.0.1 controlplane" >> /etc/hosts
                sudo swapoff -a
                sudo sed -i '/swap/d' /etc/fstab
                EOF

  tags = merge(var.tags, {
    Name = format("%s-control-plane", var.tags["Project"])
  })
}

resource "aws_instance" "node1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.daryn.instance_type
  key_name                    = var.daryn.key_name
  subnet_id                   = var.daryn.subnet_id
  vpc_security_group_ids      = [aws_security_group.sg-worker-node.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                set -xe
                hostnamectl set-hostname worker-node-1
                echo "127.0.0.1 controlplane" >> /etc/hosts
                sudo swapoff -a
                sudo sed -i '/swap/d' /etc/fstab
                EOF

  tags = merge(var.tags, {
    Name = format("%s-worker-node-1", var.tags["Project"])
  })
}

resource "aws_instance" "node2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.daryn.instance_type
  key_name                    = var.daryn.key_name
  subnet_id                   = var.daryn.subnet_id
  vpc_security_group_ids      = [aws_security_group.sg-worker-node.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                set -xe
                hostnamectl set-hostname worker-node-2
                echo "127.0.0.1 controlplane" >> /etc/hosts
                sudo swapoff -a
                sudo sed -i '/swap/d' /etc/fstab
                EOF

  tags = merge(var.tags, {
    Name = format("%s-worker-node-2", var.tags["Project"])
  })
}
