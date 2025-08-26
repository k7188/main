# Configure Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Service account for future Cloud Build executions
resource "google_service_account" "cloud_build_runner" {
  account_id   = "cloud-build-runner"
  display_name = "Cloud Build Runner Service Account"
  description  = "Service account for running Cloud Build pipelines"
}

# IAM roles for the Cloud Build service account
resource "google_project_iam_member" "cloud_build_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloud_build_runner.email}"
}

resource "google_project_iam_member" "cloud_build_service_agent" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.cloud_build_runner.email}"
}

# Cloud Build trigger for future projects (example)
resource "google_cloudbuild_trigger" "terraform_deploy" {
  name        = "terraform-deploy-trigger"
  description = "Trigger for Terraform deployments"

  github {
    owner = "your-github-username"
    name  = "clcd-cloudbuild-huss"
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
  
  substitutions = {
    _TERRAFORM_PROJECT = "example-project"
    _REGION           = "us-central1"
  }
}

# Output the service account email for reference
output "cloud_build_service_account" {
  description = "Email of the Cloud Build runner service account"
  value       = google_service_account.cloud_build_runner.email
}

output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}