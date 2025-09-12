data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu owner ID)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "terraform-idn1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Bastion Host"
  }
}
