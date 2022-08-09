resource "kubernetes_namespace" "create_namespaces_kube_hosts" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_hosts"]
  }
}

resource "kubernetes_namespace" "create_namespaces_dev" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_dev"]
  }
}

resource "kubernetes_namespace" "create_namespaces_qa" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_qa"]
  }
}

resource "kubernetes_namespace" "create_namespaces_stage" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_stage"]
  }
}

resource "kubernetes_namespace" "create_namespaces_prod" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_prod"]
  }
}

resource "kubernetes_namespace" "create_namespaces_test" {
  depends_on = [module.gke_cluster]
  count       = var.namespaces["enabled"] == "true" ? 1 : 0
  metadata {
    name = var.namespaces["env_test"]
  }
}