terraform {
    source = "./alb"
}


include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../vpc", "../main-sg", "../alb-target-groups"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "mock_vpc_id"
    public-subnet-ids = ["mock_public-subnet-ids"]
  }
}
dependency "main-sg" {
  config_path = "../main-sg"
  mock_outputs = {
    main-sg-security-group = "mock_security-group"
  }
}

dependency "alb-target-groups" {
  config_path = "../alb-target-groups"
   mock_outputs = {
     target-group-arns = "arn:aws:elasticloadbalancing:us-east-2:954235624237:targetgroup/dev-trm-cp-alb-to-nlb/f185dbb39f53d908"
  }
}


inputs = {
  alb-name                  = "web-alb"
  internal                  = "false"
  alb-sg                    = [dependency.main-sg.outputs.main-sg-security-group]
  alb-subnets               = dependency.vpc.outputs.public-subnet-ids
  alb-tag                   = "app-alb"
  target-group-arns          = dependency.alb-target-groups.outputs.target-group-arns
}