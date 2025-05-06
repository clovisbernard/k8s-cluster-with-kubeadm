# Kubernetes Cluster Setup with kubeadm-

This repository provides scripts and Terraform configurations to set up a Kubernetes cluster with 1 control plane node and 2 worker nodes using `kubeadm`. The setup includes configuring EC2 instances on AWS and installing the required Kubernetes components, including `kubeadm`, `kubectl`, and `kubelet`.

## Structure

The repository is organized into two main directories:
``` plaintext
k8s-cluster-with-kubeadm/
├── install-components/
│   ├── cilium-install.sh
│   ├── install-kubeadm-kubectl-kubelet.sh
│   ├── init-kubeadm.sh
└── terraform-files/
    ├── backend.tf
    ├── data.tf
    ├── ec2.tf
    ├── output.tf
    ├── sg.tf
    ├── variables.tf
    ├── providers.tf
    └── terraform.tfvars
```

## Prerequisites

- **AWS account**: You will need access to an AWS account and proper IAM permissions.
- **Terraform**: Install Terraform to deploy infrastructure.
- **AWS CLI**: Install and configure the AWS CLI to interact with your AWS resources.

## Setup Instructions

### step 1. Configure AWS Credentials
Make sure your AWS CLI is configured with the necessary credentials:

```bash
aws configure
```

### step 2. Deploy Infrastructure with Terraform
Run Terraform to create the EC2 instances (1 control plane and 2 worker nodes) and networking resources needed for the Kubernetes cluster.# k8s-cluster-with-kubeadm
``` bash
cd terraform-files
terraform init
terraform plan
terraform apply
```

### step 3. Install Kubernetes Components
After your EC2 instances are up and running, SSH into the control plane and worker nodes and execute the setup scripts to install kubeadm, kubectl, and kubelet.
``` bash
cd install-components
./install-kubeadm-kubectl-kubelet.sh
```
### step 4. Init kubeadm in the control plane
 SSH into the control plane and execute the setup scripts to inittialise the kubeadm
``` bash
cd install-components
./init-kubeadm.sh
```

### step 5. Join the worker nodes
Run this command on the control plane to generate the token for worker nodes:
``` bash
sudo kubeadm token create  --print-join-command
```
#### On each worker node
1. Disable Swap:
``` bash
sudo swapoff -a
```
2. Load the br_netfilter module:
``` bash
sudo modprobe br_netfilter
lsmod | grep br_netfilter
```
3. Configure iptables to allow traffic to the bridge:
``` bash
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
sudo sh -c 'echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf'
sudo sysctl -p
```

4. Execute the kubeadm join command provided earlier: 
``` bash
sudo kubeadm join ...........
```
This command will start kubelet and configure it to file /var/lib/kubelet/ocnfig.yaml

#### Check connectivity between pods.
Run the following command to check the status of the Cilium pod:
``` bash
kubectl exec -n kube-system [cilium-pod-name] -- cilium status
```
You might see this output, which indicates connectivity has failed:
``` plaintext
Cluster health:          1/3 reachable   (2025-01-14T23:24:41Z)
  Name                   IP              Node          Endpoints
  kubernetes/worker1     xxx.xx.xx.xxx   unreachable   reachable
  kubernetes/worker2     xxx.xx.xx.xxx   unreachable   reachable
Modules Health:          Stopped(0) Degraded(0) OK(43)
```
If you encounter this output, check the Cilium documentation and update the security group to ensure that the necessary ports are open.

#### Troubleshooting
After resolving the connectivity issues, you should see something like this:
```plaintext
Cluster health:          3/3 reachable   (2025-01-15T00:24:41Z)
Modules Health:          Stopped(0) Degraded(0) OK(43)
```

#### Check Connectivity with Cilium Test
Once the connectivity is fixed, run the following command to test connectivity:
``` bash
 cilium connectivity test
 ```
#### Test Pod Scheduling and Distribution
``` bash
kubectl run test --image=nginx --replicas=5
```
This will create a deployment with 5 replicas of the nginx pod. 
Check the distribution of the pods across your nodes with:
``` bash
kubectl get pods -o wide
```