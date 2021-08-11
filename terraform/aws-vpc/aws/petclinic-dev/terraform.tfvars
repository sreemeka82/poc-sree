cidr           = "10.1.0.0/16"
envname        = "tf-petclinic-dev"
region         = "ap-south-1"
pubsubnets     = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
privatesubnets = ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"]
datasubnets    = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]
azs = ["ap-south-1a","ap-south-1b","ap-south-1c"]
ami = "ami-00bf4ae5a7909786c"
type = "t2.micro"

