## For set-env.sh script configurations
environment                     =   "dev"
region                          =   "us-east-1"
s3_bucket                       =	"mypink-bucket"
s3_folder_region                =	"us-east-1"
s3_folder_project               =   "fuchicorp"
s3_folder_type                  =   "eks"
s3_tfstate_file                 =   "infrastructure.tfstate"

## After deployment of VPC you should have two security groups
security_group_ids = [
  "sg-0211aa199d5f65a78",
    "sg-06033eb39b4eb1640",
]

## Public Subnets for EKS 
public_subnets     = [
    "subnet-0aa60f6ca1401493a",
    "subnet-0ad79df971773506b",
    "subnet-02d039f5305972d30",
    "subnet-0d2b3b46a9ec9c7ad",
    ]

## Private Subnets for EKS 
private_subnets     = [
   "subnet-086ee1acafe569f7a",
    "subnet-0861034d51e042507",
    "subnet-048cc9ecfe4a83d5e",
    "subnet-08564ba25e6ba9cf8",
    ]