resource "aws_ebs_volume" "ebs-mous" {
  availability_zone = "us-east-1b"
  size              = var.ebssize

  tags = {
    Name = "ebs-${var.maintainer}"
  }
}
