variable "project_id" {
  description = "The GCP project ID for clcd-cloudbuild-huss"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}