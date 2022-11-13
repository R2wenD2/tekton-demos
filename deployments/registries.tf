locals {
  # List of roles that will be assigned to the verifier service account
  verifier_roles = toset([
    "roles/containeranalysis.notes.editor",
    "roles/containeranalysis.occurrences.editor",
  ])
}

resource "google_artifact_registry_repository" "registry" {
  location      = var.region
  repository_id = var.repository_name
  description   = "Tekton demo registry"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "binding" {
  project = google_artifact_registry_repository.registry.project
  location = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role = "roles/artifactregistry.writer"
  members = [
    "serviceAccount:${google_service_account.builder_sa.email}",
  ]
}

resource "google_project_iam_member" "verifier_role_binding" {
  for_each = local.verifier_roles
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.verifier_sa.email}"
}