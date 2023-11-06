terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.42.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
  }
}
