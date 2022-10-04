terraform {
    source = "./"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  instance-tenancy           = "default"
  enable-dns-support         = "true"
  enable-dns-hostnames       = "true"
  vpc-name                   = "webserver-vpc"
  internet-gateway-name      = "webserver-igw"
  map_public_ip_on_launch    = "true"
  public-subnets-name        = "web-public-subnets"
  public-subnet-routes-name  = "web-public-subnet-routes"
  private-subnet-name        = "web-private-subnets"
  total-nat-gateway-required = "1"
  eip-for-nat-gateway-name   = "web-eip-nat"
  nat-gateway-name           = "web-nat-gateway"
  private-route-cidr         = "0.0.0.0/0"
  private-route-name         = "web-private-route"
  vpc-cidr                   = "10.11.0.0/16"
  vpc-public-subnet-cidr     = ["10.11.1.0/24","10.11.2.0/24"]
  vpc-private-subnet-cidr    = ["10.11.4.0/24","10.11.5.0/24"]

}
