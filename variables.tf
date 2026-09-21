variable "project_name" {
  description = "Name of the project being deployed."
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "Project name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "container_image" {
  description = "Container image to deploy."
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Name assigned to the deployed container."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 80

  validation {
    condition     = var.container_port > 0 && var.container_port <= 65535
    error_message = "Container port must be between 1 and 65535."
  }
}

variable "host_port" {
  description = "Host port mapped to the application container."
  type        = number
  default     = 8080

  validation {
    condition     = var.host_port > 0 && var.host_port <= 65535
    error_message = "Host port must be between 1 and 65535."
  }
}
