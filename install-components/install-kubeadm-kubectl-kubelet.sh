#!/bin/bash
sudo swapoff -a  # disables swap for the current session.
# sysctl params required by setup, params persist across reboots


# 1 configure container runtime interface
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
# Verify that net.ipv4.ip_forward is set to 1 with:
sysctl net.ipv4.ip_forward
# Update package lists
sudo apt-get update
# Install containerd
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# 2 Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# 3 Add Kubernetes repository key and create keyring directory
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# 4 Add Kubernetes repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 5 Update package lists
sudo apt-get update

# Install Kubernetes components
sudo apt-get install -y kubelet=1.28.0-1.1 kubeadm=1.28.0-1.1 kubectl=1.28.0-1.1

# 6 Hold Kubernetes components at current version
sudo apt-mark hold kubelet kubeadm kubectl