output "master_public_ip" {
  value = module.k8s-setup.master_public_ip
}

output "node1_public_ip" {
  value = module.k8s-setup.node1_public_ip
}

output "node2_public_ip" {
  value = module.k8s-setup.node2_public_ip
}
