variable "cluster_name" {
  default     = "fuchicorp-cluster"
  description = "- (Optional) Google Cluster name."
}

variable "deployment_name" {
  default = "cluster-infrastructure"
}

variable "google_region" {
  default     = "us-central1"
  description = "- (Optional) Google Region where cluster will be deployed."
}

variable "google_domain_name" {
  default     = "fuchicorp.com"
  description = "- (Optional) The domain name for cluster."
}

variable "google_project_id" {
  default     = "get-from-console"
  description = "- (Optional) Google Project ID for the cluster."
}

variable "cluster_node_count" {
  default     = "2"
  description = "- (Optional) Count of clusters node"
}

variable "cluster_version" {
  default     = "1.16"
  description = "- (Optional) The cluster version to deploy."
}

variable "google_credentials_json" {
  default     = "~/google-credentials.json"
  description = "- (Optional) Google Service account Json file."
}

variable "disk_size_in_gb" {
  default     = "50"
  description = "- (Optional) Google Kubernetes Engine nodes disk size"
}

variable "machine_type" {
  default     = "n1-standard-2"
  description = "- (Optional) Google Kubernetes Engine nodes machine type"
}

variable "max_desired_count" {
  default     = "5"
  description = "- (Optional) Google Kubernetes Engine nodes machine type"
}

variable "min_desired_count" {
  default     = "2"
  description = "- (Optional) Google Kubernetes Engine nodes machine type"
}


variable "google_bucket_name" {
}

variable "deployment_environment" {
}

variable "namespaces" {
  type = map

  default = {
    env_hosts = "kube-hosts"
    env_dev   = "dev"
    env_qa    = "qa"
    env_stage = "stage"
    env_prod  = "prod"
    env_test  = "test"
    enabled   = "false"
  }

  description = "-(Optional) list of all namespaces for fuchicorp cluster"
}

variable "ingress_controller" {
  type = map

  default = {
    version        = "4.0.19"
    enabled        = "false"
    chart_repo_url = "https://kubernetes.github.io/ingress-nginx"
  }

  description = "-(Optional) The Ingress controller map configuration."
}

variable "external_dns" {
  type = map

  default = {
    version        = "6.1.4"
    enabled        = "false"
    chart_repo_url = "https://charts.bitnami.com/bitnami"
  }

  description = "-(Optional) The External dns map configuration."
}

variable "email" {
  default     = "contact@fuchicorp.com"
  description = "-(Optional) By default is using contact email."
}

variable "cert_manager" {
  type = map

  default = {
    version        = "1.7.2"
    enabled        = "false"
    chart_repo_url = "https://charts.jetstack.io"
  }

  description = "-(Optional) The Cert manager map configuration."
}

