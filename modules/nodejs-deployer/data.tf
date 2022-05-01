locals {
  common_tags = {
    Name = "quest"
  }
}

# This pulls AWS A-Z information
data "aws_availability_zones" "all" {}

# This Pulls default VPC_ID 
data "aws_vpc" "default" {
  default = true
} 

# This code is to get AMAZON Linux2 AMI"
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20211005.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}