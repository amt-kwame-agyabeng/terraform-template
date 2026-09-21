output "container_id" {
  description = "ID of the deployed application container."
  value       = module.deployment.container_id
}

output "container_name" {
  description = "Name of the deployed application container."
  value       = module.deployment.container_name
}

output "application_url" {
  description = "URL used to access the deployed application."
  value       = module.deployment.application_url
}
