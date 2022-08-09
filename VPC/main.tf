module "network" {
  source  = "terraform-google-modules/network/google"
  version = "5.0.0"
  
  #insert the 3 required variables here
  project_id   = var.google_project_id
  network_name = var.network_name
  subnets      = var.subnet_lists
  routes       = var.routes              #this variable is optional 
}