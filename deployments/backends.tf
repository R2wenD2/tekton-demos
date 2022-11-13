# Terraform state bucket, must exist before terraform init 
# The name of the bucket has to be globally unique
# 
# gcloud storage buckets create gs://tekton-demo-terraform-state \
#     --project=YOUR_PROJECT_ID \
#     --location=YOUR_GCP_REGION \
#     --uniform-bucket-level-access

terraform {
  backend "gcs" {
    bucket = "tekton-demo-terraform-state"
    prefix = "demo"
  }
}