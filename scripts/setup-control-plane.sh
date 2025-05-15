#!/bin/bash
set -euo pipefail

echo "=== INSTALLING KUBERNETES CONTROL PLANE ON UBUNTU 20.04 ==="

# 1. Disable swap
echo "Disabling swap..."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^/#/' /etc/fstab

# 2. Install dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 3. Configure kernel parameters for Kubernetes
echo "Configuring kernel modules and sysctl..."
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# 4. Install containerd
echo "Installing containerd..."
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# 5. Add Kubernetes repository
echo "Adding Kubernetes repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 6. Install Kubernetes components
echo "Installing kubelet, kubeadm, and kubectl..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 7. Initialize Kubernetes cluster
echo "Initializing Kubernetes control plane..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# 8. Configure kubectl for the ubuntu user
echo "Setting up kubectl for user: $USER"
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 9. Install Flannel CNI
echo "Installing Flannel network plugin..."
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# 10. Save join command to script
echo "Saving join command to /home/ubuntu/join-command.sh..."
JOIN_CMD=$(kubeadm token create --print-join-command)
echo "#!/bin/bash" | sudo tee /home/ubuntu/join-command.sh > /dev/null
echo "sudo $JOIN_CMD" | sudo tee -a /home/ubuntu/join-command.sh > /dev/null
sudo chmod +x /home/ubuntu/join-command.sh

echo "=== CONTROL PLANE SETUP COMPLETE ==="
