# Kubernetes Cluster Setup with kubeadm

This repository provides scripts and Terraform configurations to set up a Kubernetes cluster with 1 control plane node and 2 worker nodes using `kubeadm`. The setup includes configuring EC2 instances on AWS and installing the required Kubernetes components, including `kubeadm`, `kubectl`, and `kubelet`.

## Structure

The repository is organized into two main directories:

- **install-components**: Contains scripts for installing and configuring Kubernetes components on master and worker nodes.
  - `cilium-install.sh`: Script to install Cilium for CNI (Container Network Interface).
  - `install-kubeadm-kubectl-kubelet.sh`: Script to install `kubeadm`, `kubectl`, and `kubelet` on the nodes.
  - `init-kubeadm.sh`: Script to initialize the Kubernetes control plane (master node) with `kubeadm`.
  - `join-worker-node.sh`: Script to join worker nodes to the control plane.

- **terraform-files**: Contains Terraform configurations for setting up infrastructure on AWS.
  - `backend.tf`: Configures the backend for Terraform state.
  - `data.tf`: Data sources for retrieving existing AWS resources.
  - `ec2.tf`: Creates EC2 instances for the control plane and worker nodes.
  - `output.tf`: Defines the output of the Terraform apply.
  - `sg.tf`: Security group configurations for EC2 instances.
  - `variables.tf`: Defines variables used in the Terraform configurations.
  - `providers.tf`: Specifies the AWS provider configuration.
  - `terraform.tfvars`: Contains variable values to be used with the Terraform configurations.
  - `README1.md`: Basic documentation for Terraform configuration.

## Prerequisites

- **AWS account**: You will need access to an AWS account and proper IAM permissions.
- **Terraform**: Install Terraform to deploy infrastructure.
- **kubeadm**: The Kubernetes cluster is set up using `kubeadm`. Ensure you have `kubeadm`, `kubelet`, and `kubectl` installed.
- **AWS CLI**: Install and configure the AWS CLI to interact with your AWS resources.

## Setup Instructions

### step 1. Configure AWS Credentials
Make sure your AWS CLI is configured with the necessary credentials:

```bash
aws configure
```

### step 2. Deploy Infrastructure with Terraform
Run Terraform to create the EC2 instances (1 control plane and 2 worker nodes) and networking resources needed for the Kubernetes cluster.# k8s-cluster-with-kubeadm
