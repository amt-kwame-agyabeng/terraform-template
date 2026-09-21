output "container_id" {
  description = "ID of the deployed container."
  value       = docker_container.application.id
}

output "container_name" {
  description = "Name of the deployed container."
  value       = docker_container.application.name
}

output "application_url" {
  description = "URL for accessing the application."
  value       = "http://localhost:${var.host_port}"
}
