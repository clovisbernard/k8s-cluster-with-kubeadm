output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "node1_public_ip" {
  value = aws_instance.node1.public_ip
}

output "node2_public_ip" {
  value = aws_instance.node2.public_ip
}
