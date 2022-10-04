
terraform {
  source = "./"
}

include "root" {
  path = find_in_parent_folders()
}


dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "mock_vpc_id"
  }
}

inputs = {
 sg-name                 = "web-sg"  
 ingress_allows          = ["80", "443", "22"]
 protocol                = "tcp"
 cidr_blocks             = ["0.0.0.0/0"]
 outbound-rule-from-port = "0"
 outbound-rule-to-port   = "0"
  outbound-rule-protocol = "-1"
  vpc_id                 = dependency.vpc.outputs.vpc_id

}