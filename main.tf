provider "aws" {
  region = var.region
}
module "vpc" {
  source = "./modules/vpc"
}
module "database" {
  source = "./modules/database"
  priv1  = module.vpc.private1
  priv2  = module.vpc.private2
  secgrp = module.vpc.Db-sg
}
module "autoscaling" {
  source                = "./modules/autoscaling"
  aws_ssm_parameter     = module.vpc.aws_ssm_parameter
  appsg                 = module.vpc.Appserver
  bastsg                = module.vpc.Bastion
  websg = module.vpc.Webserver
  pri1                  = module.vpc.private1
  pri2                  = module.vpc.private2
  pub1                  = module.vpc.public1
  pub2                  = module.vpc.public2
  pub3                  = module.vpc.public3
  pub4                  = module.vpc.public4
  alb_target_group_arn  = module.load-balancer.target_arn
  alb_target_group_arn2 = module.load-balancer.target_arn2
}
module "load-balancer" {
  source  = "./modules/load-balancer"
  Alb     = module.vpc.Alb
  Wlb = module.vpc.Wlb
  public1 = module.vpc.public1
  public2 = module.vpc.public2
  public3 = module.vpc.public3
  public4 = module.vpc.public4
  vpc_id  = module.vpc.vpc_id
}
module "cloudwatch" {
  source = "./modules/cloudwatch"
  asgname = module.autoscaling.asgtt.name
}