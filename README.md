# Kubernetes Cluster Deployment with Terraform and Kubeadm

## Overview
This repository contains Terraform configurations and shell scripts to provision and configure a Kubernetes cluster using Kubeadm. The infrastructure is defined as code with Terraform, while cluster initialization and node joining are handled by the provided shell scripts.

## Repository Structure

```plaintext
.
├── environments/
│ └── k8s-env.yaml # Environment-specific configurations
├── modules/ # Reusable Terraform modules
│ ├── data.tf # Data sources definitions
│ ├── main.tf # Primary resource definitions
│ ├── output.tf # Module outputs
│ ├── sg.tf # Security group configurations
│ └── variables.tf # Input variables
├── resources/ # Root Terraform configurations
│ ├── main.tf # Main infrastructure definition
│ ├── output.tf # Output variables
│ ├── terraform.tfstate # Current Terraform state
│ ├── terraform.tfstate.backup # State backup
│ └── tfplan # Terraform execution plan
└── scripts/ # Cluster setup scripts
├── setup-control-plane.sh # Control plane initialization
└── setup-worker-node.sh # Worker node joining
```


## Prerequisites

- Terraform 1.0+ installed
- kubectl configured
- Cloud provider credentials configured (AWS/Azure/GCP)
- SSH key pair for node access

## Getting Started

### 1. Infrastructure Provisioning

```bash
cd resources/
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 2. Cluster Initialization
On the control plane node:
```bash
./scripts/setup-control-plane.sh
```

On worker nodes:
```bash
./scripts/setup-worker-node.sh <control-plane-ip> <token> <ca-cert-hash>
```