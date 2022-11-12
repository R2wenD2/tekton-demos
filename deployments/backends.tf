# Terraform state bucket, must exist before init 
terraform {
  backend "gcs" {
    bucket = "tekton-demo-terraform-state"
    prefix = "demo"
  }
}