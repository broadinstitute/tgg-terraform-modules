terraform {
  required_version = ">= 0.13.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.57.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.18.3"
    }
  }
}
