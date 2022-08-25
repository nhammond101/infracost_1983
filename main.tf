locals {
  resource_name_prefix = lower("test")
  region               = "eu-west-2"
}

#----- VPC --------
# Create VPC, subnets, etc
module "base_network" {
  source = "./tf-base-network/src"

  name_prefix  = local.resource_name_prefix
  region       = local.region
  subnet_count = 3
  vpc_cidr     = "10.0.0.0/16"
}

module "modulePre" {
  source = "./tf-module"
}

module "database" {
  source = "./tf-rds"

    depends_on = [module.modulePost] # Comment out this line for the costings to work
#  depends_on = [module.modulePre] # Uncomment this line for the costings to work

  availability_zones              = module.base_network.aws_region_zones[local.region]
  name_prefix                     = local.resource_name_prefix
  vpc_id                          = module.base_network.vpc_id
  vpc_private_subnets_cidr_blocks = module.base_network.subnet_cidrblocks["private"]
  vpc_subnet_ids                  = module.base_network.private_subnets_ids
}

module "modulePost" {
  source = "./tf-module"
}