# Image creation with Packer

The first we need to do to automate our infrastructure is to create a base image. This image will be used to create new servers, and it will contain all the necessary software and configurations to run our application. We will basically replicate the manual process we did in the previous chapter, but in an automated way.

## Installing Packer

You can find here how to install Packer in your OS: [Install Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)

## Creating a Packer script

Packer scripts are written in HCL (https://github.com/hashicorp/hcl). Let's start backwards, defining a fully functional Packer script and then explaining each part.

```hcl
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
```

## Understanding the Packer script

THe Packer script is divided into three main sections: `packer`, `variables`, and `build`.

### Required plugins

The first bits of the script with the `packer` section and the `variable` areis used to define the required plugins for the script. In this case, we are using the `amazon` plugin since we are going to create an AMI in AWS.

```hcl
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
```

### The build section

In the build section we find two main parts: the `source` and the `provisioners`. The former defines the source of the image we are going to use to create the new image. In this case, we are using an Ubuntu image from AWS.

```hcl
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
```

The `provisioners` section defines the steps we need to follow to configure the image. In this case, we are copying a service file and the application zip file to the server, installing Java, unzipping the application, and configuring the service to start at boot.

```hcl
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
```

Packer has a lot of provisioners that can be used to configure the image. Setting up our application is relatively simple, so the `shell` and `file` provisioners are enough.

## Executing the Packer script

The first thing we need to do is to init the Packer script. From the deploy `folder`, run:

```bash
packer init .
```

It will download the necessary plugins to run the script.

The script provided has been already formatted, but, if you need it, you can run:

```bash
packer fmt .
```

that will format the script for readability and consistency. Packer will print out the names of the files it modified, if any.

Before executing the script, you can validate it with:

```bash 
packer validate .
```

Before we actually run the build process, note that we need to provide the AWS credentials to Packer. You can do it by setting the environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
```

Now, you can finally build your AMI:

```bash
packer build agenda.pkr.hcl
```

