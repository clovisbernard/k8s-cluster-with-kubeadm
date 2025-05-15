resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.daryn.instance_type
  key_name                    = var.daryn.key_name
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

resource "null_resource" "setup_controlplane" {
  depends_on = [aws_instance.master]

  connection {
    type        = "ssh"
    host        = aws_instance.master.public_ip
    user        = "ubuntu"
    private_key = file("/Users/clovistsopgo/.ssh/aws-keys/prometheus.pem")
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "../scripts/setup-control-plane.sh"
    destination = "/home/ubuntu/setup-control-plane.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x setup-control-plane.sh",
      "./setup-control-plane.sh"
    ]
  }

  provisioner "local-exec" {
    command = "scp -i /Users/clovistsopgo/.ssh/aws-keys/prometheus.pem -o StrictHostKeyChecking=no ubuntu@${aws_instance.master.public_ip}:/home/ubuntu/join-command.sh ./join-command.sh"
  }
}



resource "null_resource" "setup_node1" {
  depends_on = [
    aws_instance.node1,
    null_resource.setup_controlplane
  ]

  connection {
    type        = "ssh"
    host        = aws_instance.node1.public_ip
    user        = "ubuntu"
    private_key = file("/Users/clovistsopgo/.ssh/aws-keys/prometheus.pem")
    timeout     = "2m"
  }

  # Copy the setup script
  provisioner "file" {
    source      = "../scripts/setup-worker-node.sh"
    destination = "/home/ubuntu/setup-worker-node.sh"
  }

  # Copy the join command script
  provisioner "file" {
    source      = "../resources/join-command.sh"
    destination = "/home/ubuntu/join-command.sh"
  }

  # Run both scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x setup-worker-node.sh join-command.sh",
      "./setup-worker-node.sh",
      "./join-command.sh"
    ]
  }
}

resource "null_resource" "setup_node2" {
  depends_on = [
    aws_instance.node2,
    null_resource.setup_controlplane
  ]

  connection {
    type        = "ssh"
    host        = aws_instance.node2.public_ip
    user        = "ubuntu"
    private_key = file("/Users/clovistsopgo/.ssh/aws-keys/prometheus.pem")
    timeout     = "2m"
  }

  # Copy the setup script
  provisioner "file" {
    source      = "../scripts/setup-worker-node.sh"
    destination = "/home/ubuntu/setup-worker-node.sh"
  }

  # Copy the join command script
  provisioner "file" {
    source      = "../resources/join-command.sh"
    destination = "/home/ubuntu/join-command.sh"
  }

  # Run both scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x setup-worker-node.sh join-command.sh",
      "./setup-worker-node.sh",
      "./join-command.sh"
    ]
  }
}
