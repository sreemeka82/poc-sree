1) install the terraform and setup the path 
2) install the aws cli and configure the keys
profiles for the aws cli : your user home directory .aws
config /credentials 

argument(input) / attributes (outputs)

terraform.exe plan --var-file dev.tfvars
what is tfstate ?
resource information

1) create the scenario for the forece replacement - force replacment


we are going to create the vpc using the terraform 
provider: aws
region : 
resource: vpc 
cidr: 10.1.0.0/16 
enable dns = tru 

subnets 
pubsubnet = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
enable public ip 
privatesubnet = ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"]
datasubnet = = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]

igw =
attach  =

eip=
nat = pubsubnet[0]

route table 
pubroute
privateroute

associate the pubsunets with the igw in pubroute
associate the privatesunets with the nat-gw in private route















terraform init
terraform plan
terraform apply 