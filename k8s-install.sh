#!/bin/bash

set -e

RESOURCE_DIR="resources"

echo "[INFO] Switching to Terraform directory: $RESOURCE_DIR"
cd "$RESOURCE_DIR"

echo "[INFO] Initializing Terraform..."
terraform init

if [[ "$1" == "-destroy" ]]; then
    echo "[INFO] Destroying Terraform-managed infrastructure..."
    terraform destroy -auto-approve
    echo "[INFO] Terraform destroy complete."
else
    echo "[INFO] Planning Terraform changes..."
    terraform plan -out=tfplan

    echo "[INFO] Applying Terraform changes..."
    terraform apply tfplan

    echo "[INFO] Terraform apply complete."
fi

cd ..
