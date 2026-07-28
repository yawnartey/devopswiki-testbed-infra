terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"

    }
  }

  backend "s3" {
    bucket       = "devops-wiki-tf-state-bucket-c9123c3a736c3547"
    key          = "infrastructure-testbed/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "lync"
  }
}

provider "aws" {
  region  = "eu-west-3"
  profile = "lync"
}

# networking module
module "networking" {
  source = "./networking"
}

# security group module
module "security_group" {
  source = "./security"
  vpc_id = module.networking.vpc_id
}

# iam module
module "iam" {
  source = "./iam"
}

# compute module
module "compute" {
  source                        = "./compute"
  subnet_ids                    = module.networking.subnet_ids
  testbed_fe_security_group_id  = module.security_group.testbed_fe_security_group_id
  testbed_be_security_group_id  = module.security_group.testbed_be_security_group_id
  testbed_instance_profile_name = module.iam.testbed_instance_profile_name
  yaw_public_key                = var.yaw_public_key
  postgres_user                 = var.postgres_user
  postgres_password             = var.postgres_password
}

# dns module
module "dns" {
  source               = "./dns"
  testbed_fe_public_ip = module.compute.testbed_fe_public_ip
}
