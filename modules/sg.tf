resource "aws_security_group" "sg-control-plane" {
  name_prefix = format("%s-control-plane", var.tags["Project"])
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubernetes API server"
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "etcd server client API"
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Kubelet API"
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "kube-scheduler"
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "kube-controller-manager"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description      = "All ICMP from master"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "All ICMP from node"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom UDP"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom UDP"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 4240
    to_port          = 4240
    protocol         = "tcp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 4240
    to_port          = 4240
    protocol         = "tcp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }



  tags = merge(var.tags, {
    Name = format("%s-control-plane",var.tags["Project"])
    },
  )
}




resource "aws_security_group" "sg-worker-node" {
  name_prefix = format("%s-worker-node",var.tags["Project"])
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Kubelet API"
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NodePort Services"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description      = "All ICMP from master"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "All ICMP from node"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom UDP"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom UDP"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 4240
    to_port          = 4240
    protocol         = "tcp"
    security_groups  = ["sg-01973c1a7168a5935"]
  }

  ingress {
    description      = "Custom TCP"
    from_port        = 4240
    to_port          = 4240
    protocol         = "tcp"
    security_groups  = ["sg-0660a17e2ffb12379"]
  }
  tags = merge(var.tags, {
    Name = format("%s-node",var.tags["Project"])
    },
  )
}
