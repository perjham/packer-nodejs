####################
# VARIABLES AWS
####################
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
####################
# VARIABLES AZURE
####################
variable "location" {
  default = "East US"
}
variable "resource_group_name" {
  default = "prueba"
}
variable "azure_image_name" {
  default = "rockylinux-9"
}
####################
# SOURCES
####################
source "amazon-ebs" "example" {
  ami_name      = var.ami_name
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami    = var.ami_id
  ssh_username  = var.ssh_username
}
source "azure-arm" "example" {
  location             = var.location
  image_publisher      = "Rocky-Linux"
  image_offer          = "rockylinux"
  image_sku            = "9"
  os_type              = "Linux" 
  managed_image_resource_group_name = var.resource_group_name
  managed_image_name   = var.azure_image_name
}
####################
# BUILDERS
####################
build {
  sources = [
    "source.amazon-ebs.example",
    "source.azure-arm.example"
  ]
  provisioner "shell" {
    script = "entrypoint.sh"
  }
}