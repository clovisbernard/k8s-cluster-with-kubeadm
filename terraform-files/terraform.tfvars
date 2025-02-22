aws_region = "us-east-1"
# ami           = "ami-007855ac798b5175e"
instance_type = "t2.medium"
key_name      = "prometheus"
subnet_id     = "subnet-0c865055b7d71c13f"
common_tags = {
  "AssetID"       = "2024"
  "AssetName"     = "k8s"
  "Teams"         = "Del"
  "Environment"   = "Dev"
  "Project"       = "Training"
  "CreateBy"      = "Clovis"
  "cloudProvider" = "aws"
}
