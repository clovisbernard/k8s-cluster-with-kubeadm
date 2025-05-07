#!/bin/bash
set -e

echo "██████████████████████████████████████████████████████████████████████"
echo "█                     WORKER NODE SETUP SCRIPT                      █"
echo "██████████████████████████████████████████████████████████████████████"

# 1. DISABLE SWAP
echo "▶ Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 2. INSTALL DEPENDENCIES
echo "▶ Installing dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. SETUP CONTAINERD
echo "▶ Installing containerd..."
sudo apt-get install -y -qq containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd >/dev/null

# 4. CONFIGURE KERNEL MODULES
echo "▶ Configuring kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# 5. CONFIGURE NETWORK SETTINGS
echo "▶ Configuring network settings..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system >/dev/null

# 6. ADD KUBERNETES REPOSITORY
echo "▶ Adding Kubernetes repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 7. INSTALL KUBERNETES COMPONENTS
echo "▶ Installing kubelet, kubeadm..."
sudo apt-get update -qq
sudo apt-get install -y -qq kubelet kubeadm
sudo apt-mark hold kubelet kubeadm >/dev/null

# 8. VERIFY SETUP
echo "▶ Verifying installation..."
sudo systemctl is-active containerd >/dev/null || { echo "❌ Containerd not running"; exit 1; }
lsmod | grep -q br_netfilter || { echo "❌ br_netfilter not loaded"; exit 1; }

echo "██████████████████████████████████████████████████████████████████████"
echo "█                     SETUP COMPLETE!                               █"
echo "█                                                                   █"
echo "█ Run the join command from your control plane:                     █"
echo "█ sudo kubeadm join <control-plane-ip>:6443 \                       █"
echo "█   --token <token> \                                               █"
echo "█   --discovery-token-ca-cert-hash sha256:<hash>                    █"
echo "██████████████████████████████████████████████████████████████████████"