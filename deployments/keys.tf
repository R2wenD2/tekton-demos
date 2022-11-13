# Configure Key Management Service.

locals {
  # List of roles that will be used by VERIFIER_SA to sign attestations
  attestation_roles = toset([
    "roles/cloudkms.cryptoOperator",
    "roles/cloudkms.viewer",
  ])
}

resource "google_kms_key_ring" "chains_key_ring" {
  name     = var.key_ring_name
  location = var.region
}

# Private key for VERIFIER_SA to sign attestations.
resource "google_kms_crypto_key" "chains_key" {
  name     = "${var.key_ring_name}-chains-key"
  key_ring = google_kms_key_ring.chains_key_ring.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_2048_SHA256"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "chains_key_binding" {
    for_each      = local.attestation_roles
    crypto_key_id = google_kms_crypto_key.chains_key.id
    role          = each.value

    members = [
        "serviceAccount:${google_service_account.verifier_sa.email}",
    ]
}
