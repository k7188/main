terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    # These will be set by Cloud Build via environment variables
    # bucket = "your-terraform-state-bucket"
    # prefix = "project-name"
  }
}