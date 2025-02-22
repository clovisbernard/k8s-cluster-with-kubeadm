################### S3 as BACKEND ############################
terraform {
  backend "s3" {
    bucket         = "2560-clovis-s4-state"
    key            = "k8s-install/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-clovis-s4-state-lock"
  }
}