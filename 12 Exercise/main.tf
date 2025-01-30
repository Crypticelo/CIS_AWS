terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_az" {
  description = "AZ in which we launch instance"
  default = "a"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami = "ami-08cf815cff6ee258a"
  instance_type = "t4g.micro"
  availability_zone = "us-east-1${var.aws_az}"
  count = 3

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = 1.0
    }
  }

  tags = {
    Name = "My-Instance-${count.index}"
  }
}

#resource "aws_instance" "my_other_instance" {
#  ami = "ami-08cf815cff6ee258a"
#  instance_type = "c7g.medium"

 # tags = {
#    Name = "My-Other-Instance"
#  }
#}