provider "aws" {
#    region = "ap-southeast-2"    
}

#variable "vpc_cidr_block" {
#  description = "vpc cidr block"
#}

variable "cidr_blocks" {
  description = "cidr blocks for VPC and subnets"
  #default = "10.0.10.0/24"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

#variable "environment" {
#  description = "deployment environment"
#}

resource "aws_vpc" "development_vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name = var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "development_subnet_1" {
  vpc_id            = aws_vpc.development_vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = var.cidr_blocks[1].name
   # vpc_env = Dev_new_vpc
  }
}
data "aws_vpc" "default_vpc"{
    default = true
}

resource "aws_subnet" "development_subnet_2" {
    vpc_id = data.aws_vpc.default_vpc.id
    cidr_block = var.cidr_blocks[2].cidr_block
    availability_zone = "ap-southeast-2a"
    tags = {
        Name = var.cidr_blocks[2].name
      #  vpc_env = Dev_existing_vpc
    }
}

output "development_vpc_id" {
  value=aws_vpc.development_vpc.id
}
output "development_subnet_1_id" {
  value=aws_subnet.development_subnet_1.id
}
output "default_vpc_id" {
  value=data.aws_vpc.default_vpc.id
}
output "development_subnet_2_id" {
  value=aws_subnet.development_subnet_2.id
}

