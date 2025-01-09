packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.0"
    }
  }
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "agenda_version" {
  type    = string
  default = "1.0-SNAPSHOT"
}

source "amazon-ebs" "ubuntu-agenda" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  region        = "eu-south-2"
  source_ami    = "ami-01d67cc599f23990b"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"
  ami_name      = "agenda-app-${var.agenda_version}"
  tags = {
    Version = "${var.agenda_version}"
  }
}


build {
  sources = ["source.amazon-ebs.ubuntu-agenda"]

  provisioner "file" {
    source      = "agenda.service"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "../target/universal/agenda-${var.agenda_version}.zip"
    destination = "/home/ubuntu/agenda.zip"
  }

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt install -y openjdk-17-jdk-headless unzip",
      "unzip /home/ubuntu/agenda.zip",
      "sudo mv /home/ubuntu/agenda-${var.agenda_version} /home/ubuntu/agenda",
      "sudo cp /home/ubuntu/agenda.service /etc/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable agenda.service"
    ]
  }
}