# Kubernetes Cluster Deployment with Terraform and Kubeadm

## Overview
This repository automates the end-to-end provisioning of a Kubernetes cluster on AWS using Terraform and Kubeadm. The infrastructure is defined as code using Terraform to provision EC2 instances, security groups, and networking within the default VPC. Once provisioned, the cluster is initialized via shell scripts that configure the control plane and seamlessly join worker nodes.

The goal is to provide a production-style setup with no manual intervention. This approach ensures reproducibility, scalability, and maintainability of your Kubernetes infrastructure using Infrastructure as Code (IaC) principles.

Key Features:

Automated provisioning of a 3-node Kubernetes cluster (1 control plane, 2 worker nodes)

  - Kubernetes v1.28.1 installed using kubeadm
  - SSH-based remote execution via Terraform null_resource provisioners
  - Hostname assignment and swap disabling for Kubernetes readiness
  - Dynamic creation and distribution of the kubeadm join command
  - Clean destruction and teardown with a single script
This setup is ideal for DevOps engineers, SREs, or learners looking to understand how Kubernetes clusters can be bootstrapped manually while leveraging modern automation tools.

## Repository Structure
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

### 2. Launch the cluster
Run the install script in the root folder:
```bash
bash k8s-install.sh
```
This will:
  - Initialize Terraform
  - Create the infrastructure
  - Set up the Kubernetes control plane
  - Join the worker nodes

### 3. Connecting to Your Cluster
SSH into the control plane:
```bash
ssh -i ~/.ssh/YOUR_KEY.pem ubuntu@<control_plane_public_ip>
```
Then check node status:
```bash
kubectl get nodes
```
### 4.Destroy Cluster
Run the destroy script in the root folder:
```bash
bash k8s-install.sh -destroy
```
This will destroy all Terraform-managed AWS resources.