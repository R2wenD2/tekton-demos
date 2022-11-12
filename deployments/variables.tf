# List of variables which can be provided ar runtime to override the specified defaults 

variable "project_id" {
  description = "GCP project ID"
  type        = string
  nullable    = false
}

variable "region" {
  description = "GCP region"
  type        = string
  nullable    = false
}

variable "builder_sa" {
  description = "Tekton Builder SA"
  type        = string
  default     = "tekton-builder-sa"
}

variable "verifier_sa" {
  description = "Tekton Verifier SA"
  type        = string
  default     = "tekton-verfier-sa"
}

variable "repository_name" {
  description = "Artifact Registry Name"
  type        = string
  default     = "tekton-demo"
}
