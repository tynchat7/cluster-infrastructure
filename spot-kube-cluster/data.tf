## Provider connection block used by terraform to cluster after it got created in order to do Helm Deployments
data "google_client_config" "provider" {
  depends_on = [module.gke_cluster]
}


data "google_container_cluster" "gke_cluster" {
  depends_on = [module.gke_cluster]
  name       = var.cluster_name
  location   = var.google_region
  project    = var.google_project_id
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}
