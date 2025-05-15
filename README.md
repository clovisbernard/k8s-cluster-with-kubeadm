# Kubernetes Cluster Deployment with Terraform and Kubeadm

## Overview
This repository contains Terraform configurations and shell scripts to provision and configure a Kubernetes cluster using Kubeadm. The infrastructure is defined as code with Terraform, while cluster initialization and node joining are handled by the provided shell scripts.

## Repository Structure

```plaintext
.
├── environments
│   └── k8s-env.yaml
├── k8s-install.sh
├── modules
│   ├── data.tf
│   ├── main.tf
│   ├── output.tf
│   ├── sg.tf
│   └── variables.tf
├── README.md
├── resources
│   ├── main.tf
│   ├── output.tf
└── scripts
    ├── setup-control-plane.sh
    └── setup-worker-node.sh

```


## Prerequisites

- Terraform 1.0+ installed
- kubectl configured
- Cloud provider credentials configured (AWS)
- SSH key pair for node access

## Getting Started

### 1.Clone the repo
```bash
git https://github.com/clovisbernard/k8s-cluster-with-kubeadm.git
cd k8s-cluster-with-kubeadm
```

### 2.Edit variables
Update the values in environments/k8s.yaml.

```plaintext
k8s:
  aws_region: "us-east-1"
  instance_type : "t2.medium"
  key_name      : "prometheus"
```

### 2. Cluster Initialization
On the control plane node:
```bash
./scripts/setup-control-plane.sh
```

### 3. Launch the cluster
Run the install script in the root folder:
```bash
bash k8s-install.sh
```
This will:
  - Initialize Terraform
  - Create the infrastructure
  - Set up the Kubernetes control plane
  - Join the worker nodes

### 4. Connecting to Your Cluster
SSH into the control plane:
```bash
ssh -i ~/.ssh/YOUR_KEY.pem ubuntu@<control_plane_public_ip>
```
Then check node status:
```bash
kubectl get nodes
```
### 5.Destroy Cluster
Run the destroy script in the root folder:
```bash
bash k8s-install.sh -destroy
```
This will destroy all Terraform-managed AWS resources.