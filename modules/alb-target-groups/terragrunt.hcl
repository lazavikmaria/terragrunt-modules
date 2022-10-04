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
  #Application Load Balancer Target Group
  alb-tg-name               = "web"
  target-group-port         = "80"
  target-group-protocol     = "HTTP"
  vpc-id                    = dependency.vpc.outputs.vpc_id
}