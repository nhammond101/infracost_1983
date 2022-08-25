locals {
  aws_region_zones = tomap({
    "ap-northeast-2" = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c", "ap-northeast-2d"]
    "eu-west-2"      = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    "us-east-1"      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    "us-east-2"      = ["us-east-2a", "us-east-2b", "us-east-2c"]
  })
  subnet_count         = min(length(local.aws_region_zones[var.region]), var.subnet_count)
  subnet_cidrs         = cidrsubnets(var.vpc_cidr, [for v in range(local.subnet_count * 2) : 3]...)
  private_subnet_cidrs = slice(local.subnet_cidrs, local.subnet_count, length(local.subnet_cidrs))
  public_subnet_cidrs  = slice(local.subnet_cidrs, 0, local.subnet_count)

}

module "base-network" {
  source  = "cn-terraform/networking/aws"
  version = "2.0.16"

  availability_zones                          = local.aws_region_zones[var.region]
  name_prefix                                 = var.name_prefix
  private_subnets_cidrs_per_availability_zone = local.private_subnet_cidrs
  public_subnets_cidrs_per_availability_zone  = local.public_subnet_cidrs
  single_nat                                  = var.single_nat
  vpc_cidr_block                              = var.vpc_cidr
}

data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [module.base-network.vpc_id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}
