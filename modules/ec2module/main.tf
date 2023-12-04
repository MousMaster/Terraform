data "aws_ami" "ubuntu-linux-1804" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}


resource "aws_instance" "myec2" {
  ami             = data.aws_ami.ubuntu-linux-1804.id
  instance_type   = var.instancetype
  key_name        = var.ssh_key
  tags            = var.aws_common_tag
  security_groups   = ["${var.sg_name}"]
  availability_zone = var.AZ


root_block_device {
    delete_on_termination = true
  }

  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${var.public_ip} >> IP_ec2.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
    connection {
      type        = "ssh"
      user        = var.user
      private_key = file("../../../cle.pem")
      host        = self.public_ip
    }
  }


}











