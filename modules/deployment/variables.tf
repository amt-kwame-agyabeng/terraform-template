variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "container_image" {
  description = "Container image to deploy."
  type        = string
}

variable "container_name" {
  description = "Name assigned to the container."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container."
  type        = number
}

variable "host_port" {
  description = "Port exposed on the host."
  type        = number
}
