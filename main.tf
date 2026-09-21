module "deployment" {
  source = "./modules/deployment"

  project_name    = var.project_name
  environment     = var.environment
  container_image = var.container_image
  container_name  = var.container_name
  container_port  = var.container_port
  host_port       = var.host_port
}
