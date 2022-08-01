module "project-services" {
  count   = var.apis_to_enable ? 1 : 0
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.1.1"

  project_id = google_project.current_project.id

  activate_apis = var.apis_to_enable
}

# we always need these in gnomAD-ish projects
module "default-project-services" {
  count   = var.enable_default_services ? 1 : 0
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.1.1"

  project_id = google_project.current_project.id

  activate_apis = [
    "dataproc.googleapis.com",
    "cloudfunctions.googleapis.com",
    "compute.googleapis.com"
  ]
}
