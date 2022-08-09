module "gke_cluster" {
  source             = "fuchicorp/gke/google"
  version            = "0.0.2"
  cluster_name       = "${var.cluster_name}"
  google_region      = "${var.google_region}"
  google_project_id  = "${var.google_project_id}"
  cluster_node_count = "${var.cluster_node_count}"
  cluster_version    = "${var.cluster_version}"
  google_credentials = "${var.google_credentials_json}"
  disk_size_in_gb    = "${var.disk_size_in_gb}"
  machine_type       = "${var.machine_type}"
}
