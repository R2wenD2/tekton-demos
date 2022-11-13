# List of variables which can be provided ar runtime to override the specified defaults 

variable "project_id" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "region" {
  description = "GCP Region"
  type        = string
  nullable    = false
}

variable "zone" {
  description = "GCP Region Zone"
  type        = string
  nullable    = false
}

variable "builder_sa" {
  description = "Tekton Builder SA"
  type        = string
  default     = "builder"
}

variable "verifier_sa" {
  description = "Tekton Verifier SA"
  type        = string
  default     = "tekton-chains-controller"
}

variable "repository_name" {
  description = "Artifact Registry Name"
  type        = string
  default     = "tekton-demo"
}

variable "key_ring_name" {
  description = "KMS Ring Name"
  type        = string
  default     = "tekton-chains"
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "tekton"
}

variable "node_type" {
  description = "GKE Node Type"
  type        = string
  default     = "e2-medium"
}
