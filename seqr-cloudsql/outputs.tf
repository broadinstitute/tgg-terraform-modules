output "cloudsql-instance-name" {
  value = google_sql_database_instance.postgres_cloudsql_instance.name
}
