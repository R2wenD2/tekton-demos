# Create builder_sa. Used to AuthN/AuthZ all GCP API invications during build.
resource "google_service_account" "builder_sa" {
  account_id   = var.builder_sa
  display_name = "Tekton Builder Service Account"
}

# Set up VERIFIER_SA. Used to verify built images.
resource "google_service_account" "verifier_sa" {
  account_id   = var.verifier_sa
  display_name = "Image Verification Service Account"
}
