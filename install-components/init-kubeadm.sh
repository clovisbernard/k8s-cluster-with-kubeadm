#!/bin/bash
    # sudo modprobe br_netfilter
    # echo "br_netfilter" | sudo tee /etc/modules-load.d/k8s.conf
    # sudo tee /etc/sysctl.d/k8s.conf<<EOF
    # net.bridge.bridge-nf-call-iptables = 1
    # net.bridge.bridge-nf-call-ip6tables = 1
    # EOF
    # sudo sysctl --system
    # sudo sysctl net.bridge.bridge-nf-call-iptables
    # sudo sysctl net.bridge.bridge-nf-call-ip6tables
    # sudo kubeadm init

---
#!/bin/bash
        # run this command in the control plane 
sudo modprobe br_netfilter
echo "br_netfilter" | sudo tee /etc/modules-load.d/k8s.conf
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
cat /proc/sys/net/bridge/bridge-nf-call-iptables
sudo kubeadm init

----
# Create the .kube directory
mkdir -p ~/.kube
# move config file to /.kube folder
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
# change config file owner 
sudo chown $(id -u):$(id -g) ~/.kube/config
# we don't need to use sudo anymore
---
# organise resource in namespace