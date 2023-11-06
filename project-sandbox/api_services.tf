module "project-services" {
  count   = length(var.apis_to_enable) > 0 ? 1 : 0
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "13.0.0"

  project_id = google_project.current_project.id

  activate_apis = var.apis_to_enable

  disable_dependent_services  = false
  disable_services_on_destroy = false
}

# we always need these in gnomAD-ish projects
module "default-project-services" {
  count   = var.enable_default_services ? 1 : 0
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "13.0.0"

  project_id = google_project.current_project.id

  activate_apis = [
    "dataproc.googleapis.com",
    "cloudfunctions.googleapis.com",
    "compute.googleapis.com",
  ]

  disable_dependent_services  = false
  disable_services_on_destroy = false
}
