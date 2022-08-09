#Defining Domain Name
variable "google_domain_name" {
  description = "the name of the domain"
  type        = string
  default     = "awskirk.com"
}
#Defining Bucket Name
variable "google_bucket_name" {
  description = "the name of the bucket"
  type        = string
  default     = "fuchicorp-veronica5-bucket"
}

#Defining Deployment Environment
variable "deployment_environment" {
  description = "the name of the deployment environment"
  type        = string
  default     = "tools"
}
#Defining Deployment Name
variable "deployment_name" {
  description = "the name of the deployment"
  type        = string
  default     = "vpc"
}
#Defining Network Name
variable "network_name" {
  description = "the name of the network"
  type        = string
  default     = "fuchicorp-vpc"
}
#Defining Project ID
variable "google_project_id" {
  description = "project where VPC will be created"
  type        = string
  default     = "fuchicorp-project-ali"
}
#Defining Google region where the cluster will be deployed
variable "google_region" {
  description = "Region where VPC will be created"
  type        = string
  default     = "us-west1-b"
}
# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.10.10.0/24"
}
# Defining CIDR Block for 1st Private Subnet
variable "public_subnet_cidr" {
  default = "10.0.40.0/24"
}
# Defining CIDR Block for 2nd Private Subnet
variable "private_subnet1_cidr" {
  default = "10.0.10.0/24"
}
# Defining CIDR Block for 3rd Private Subnet
variable "private_subnet2_cidr" {
  default = "10.0.20.0/24"
}
# Defining CIDR Block for Public Subnet
variable "private_subnet3_cidr" {
  default = "10.0.30.0/24"
}
# Defining CIDR Block for VPC
variable "subnet_lists" {
  type = list
  default = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.40.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "private-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "private-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "private_subnet"
    },
    {
      subnet_name               = "private-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
}
# Defining CIDR Routes for VPC
variable "routes" {
  type = list
  default = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}