packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0453ec754f44f9a4a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_username" {
  default = "ec2-user"
}

variable "ami_name" {
  default = "al2-node"
}

source "amazon-ebs" "example" {
  ami_name      = var.ami_name
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami    = var.ami_id
  ssh_username  = var.ssh_username
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    script = "entrypoint.sh"
  }
}