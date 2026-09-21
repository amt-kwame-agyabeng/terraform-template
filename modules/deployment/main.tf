resource "docker_image" "application" {
  name = var.container_image
}

resource "docker_container" "application" {
  name  = var.container_name
  image = docker_image.application.image_id

  ports {
    internal = var.container_port
    external = var.host_port
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }
}
