
## Updating the local cluster DNS
resource "null_resource" "wait_kubernetes_endpoint" {
  depends_on = [
    module.gke_cluster
  ]

  provisioner "local-exec" {
    command = <<EOF
    ## Getting the kube config access 
    gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.google_region} --project ${var.google_project_id}

    ## Making sure the Kubernetes endpoint ready!!
    while ! kubectl get endpoints &> /dev/null 
    do
      echo 'if the cluster created waiting for endpoint to be ready!!'
      sleep 1
    done
EOF
  }
}
