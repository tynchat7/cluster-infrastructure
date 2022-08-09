# Terraform module to create VPC and subnets 

## To be able to use following terraform VPC module please follow the documentation below:

# Requirements: 

Use FuchiCorp latest terraform version ` gtfswitch v0.13.7 --show-latest-stable 0.13 prints 0.13.7 `

# Usage:

Step 1: Clone the repository
```
git clone https://github.com/fuchicorp/cluster-infrastructure.git
cd cluster-infrastructure/VPC
```

Step 2. Create a ` vpc.tfvars` file and customize your own variables like below:
```
google_domain_name     = "" # Write your domain name
google_project_id      = "" # Write your project id from google cloud
google_bucket_name     = "" # Write your bucket name from google cloud
deployment_environment = "tools"
deployment_name        = "vpc"
google_region          = "us-west1-b"
subnet_lists = [
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
routes = [
  {
    name              = "egress-internet"
    description       = "route through IGW to access internet"
    destination_range = "0.0.0.0/0"
    tags              = "egress-inet"
    next_hop_internet = "true"
  },
]

```
Step 3. Copy ` source set-env.sh ` file from cluster-infrastructure to ` VPC folder`

Step 4. After you have configured all of the above, you should be able to create the VPC, Subnets and Route Table by running the following commands:
```
source set-env.sh vpc.tfvars
terraform apply -var-file $DATAFILE -auto-approve 
```
### Additional details about the Terraform Module used can be found here:
 https://registry.terraform.io/modules/terraform-google-modules/network/google/latest
