region         = "eu-central-1"
name           = "prime-service"
ami            = "ami-05852c5f195d545ea" # Replace with a valid AMI ID for your region (e.g., Ubuntu 22.04)
instance_type  = "t3.micro"              # Replace with desired instance type
user_data_path = "../../user_data.sh"

vpn_port = 51820

tags = {
  Environment = "dev"
  Project     = "prime-service"
  Owner       = "sandeep"
}