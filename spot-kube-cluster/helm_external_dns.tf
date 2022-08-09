## Deploying the external dns 
module "external-dns" {
  depends_on = [
    module.gke_cluster, kubernetes_namespace.create_namespaces_kube_hosts
  ]
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.12"
  deployment_name        = "external-dns"
  deployment_environment = var.namespaces["env_hosts"]
  deployment_endpoint    = var.google_domain_name
  deployment_path        = "external-dns"
  enabled                = var.external_dns["enabled"]
  remote_chart           = "true"
  release_version        = var.external_dns["version"]
  chart_repo             = var.external_dns["chart_repo_url"]

  remote_override_values = <<EOF
provider: google
google:
  project: ${var.google_project_id}
  serviceAccountSecret: "google-service-account"
EOF
}

## Creating the secret for External DNS to manage DNS 
resource "kubernetes_secret" "external_dns_secret" {
  depends_on = [
    module.gke_cluster, kubernetes_namespace.create_namespaces_kube_hosts
  ]
  count       = var.external_dns["enabled"] == "true" ? 1 : 0

  metadata {
    name      = "google-service-account"
    namespace = var.namespaces["env_hosts"]
  }

  data = {
    "credentials.json" = file(pathexpand("~/google-credentials.json"))
  }

  type = "generic"
}

## Updating the local cluster DNS
resource "null_resource" "kube_dns" {
  depends_on = [
    module.gke_cluster, kubernetes_namespace.create_namespaces_kube_hosts, module.external-dns, null_resource.wait_kubernetes_endpoint
  ]
  count       = var.external_dns["enabled"] == "true" ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
    kubectl apply -f terraform_templates/kube-dns.yaml
EOF
  }
}
