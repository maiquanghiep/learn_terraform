variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
    description = "Address range for VPC"
}

variable "public_subnet_cidr_block" {
    default = "10.0.1.0/24"
    description = "Address range for Public subnet"
}

variable "private_subnet_cidr_block" {
    default = "10.0.2.0/24"
    description = "Address range for Public subnet"
}