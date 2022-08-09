## Cert manager helm deployment
module "cert_manager_deploy" {
  depends_on = [
    module.gke_cluster, kubernetes_namespace.create_namespaces_kube_hosts
  ]
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.12"
  deployment_name        = "cert-manager"
  deployment_environment = var.namespaces["env_hosts"]
  deployment_endpoint    = "cert-manager.${var.google_domain_name}"
  enabled                = var.cert_manager["enabled"]
  remote_chart           = "true"
  deployment_path        = "cert-manager"
  release_version        = var.cert_manager["version"]
  chart_repo             = var.cert_manager["chart_repo_url"]


  ## The Cert-Manager values configurations
  remote_override_values = <<EOF
installCRDs: true
EOF
}

data "template_file" "cert_manager_cluster_issuer" {
  depends_on = [
    module.gke_cluster, kubernetes_namespace.create_namespaces_kube_hosts
  ]
  template = file("terraform_templates/cert-manager/cluster-issuer-prod.yaml")

  vars = {
    google_project_id   = var.google_project_id
    clusterissuer_email = var.email
  }
}


## Creating the cluster issuer for cert manager
resource "null_resource" "cert_manager_cluster_issuer" {
  depends_on = [
    module.gke_cluster, null_resource.wait_kubernetes_endpoint, module.cert_manager_deploy
  ]
  count       = var.cert_manager["enabled"] == "true" ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    
    ## Waiting until the cluster issuer can be craeted
    while ! kubectl get clusterissuer &> /dev/null 
    do
      echo 'Waiting until Custom Resource Definitions are ready!!'
      sleep 1
    done

    ## Creating the cluster issuer
    echo "${data.template_file.cert_manager_cluster_issuer.rendered}" > terraform_templates/cert-manager/cluster-issuer-prod-ignoreme.yaml
    kubectl apply --validate=false -f terraform_templates/cert-manager/cluster-issuer-prod-ignoreme.yaml
EOF
  }

}
