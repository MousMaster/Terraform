provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["../../aws_credentials"]

}

terraform {
  backend "s3" {
    bucket     = "devops-mous"
    key        = "mous.tfstate"
    region     = "us-east-1"
    access_key = ""
    secret_key = ""

  }
}

module "sg" {
  source = "../modules/sgmodule"
}

module "ebs" {
  source = "../modules/ebsmodule"
}



module "ip_public" {
  source = "../modules/ippublicmodule"

}


module "ec2" {
  source       = "../modules/ec2module"
  instancetype = "t2.micro"
  public_ip    = module.ip_public.output_eip
  sg_name      = module.sg.output_sg_name
}

#Creation des associations nécessaires
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2.output_ec2_id
  allocation_id = module.ip_public.output_eip_id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.ebs_id
  instance_id = module.ec2.output_ec2_id
}





