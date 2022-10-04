terraform {
    source = "./"
}



include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../vpc", "../main-sg", "../alb-target-groups", "../alb"]
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

dependency "alb" {
  config_path = "../alb"
  skip_outputs = true
}



inputs = {

  launch-configuration-name                          = "ec2-instance"
  launch-configuration-ami-id                        = "ami-0cff7528ff583bf9a"
  launch-configuration-security-groups               = [dependency.main-sg.outputs.main-sg-security-group]
  launch-configuration-instance-type                 = "t3.micro"
  launch-configuration-root-block-device-volume-type = "gp2"
  launch-configuration-root-block-volume-size        = "30"
  user-data                                          = file("../auto-scaling/scripts/user-data.sh")

  #Auto-Scaling

  autoscaling-group-name                            = "ec2-asg"
  max-size                                          = "2"
  min-size                                          = "1"
  health-check-grace-period                         = "300"
  desired-capacity                                  = "2"
  force-delete                                      = "true"
  #A list of subnet IDs to launch resources in
  vpc-zone-identifier                               = dependency.vpc.outputs.public-subnet-ids
  target-group-arns                                 = [dependency.alb-target-groups.outputs.target-group-arns]
  health-check-type                                 = "ELB"
  tag-key                                           = "Name"
  tag-value                                         = "web-ec2-instance"
}