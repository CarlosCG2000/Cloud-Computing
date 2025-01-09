# Creating an EC2 instance
The first step is to create an EC2 instance. To do this, we need to go to the AWS console and click on the `EC2` service. Once there, we need to click on the `Launch Instance` button. This will open a wizard that will guide us through the process of creating a new instance. Make sure to select the latest Ubuntu Server LTS version and an instance type that's included in the free tier.

We can leave the default settings for now. As we progress through the wizard, we will be asked to create a new key pair. This key pair will be used to connect to the instance via SSH. Make sure to download the key pair and store it in a safe place.

At this point we should have a new instance running. We can connect to it via SSH using the key pair we created earlier. The SSH command will look something like this:

```bash
ssh -i /path/to/keypair.pem
```

## Installing the necessary software
Once we are connected to the instance, we need to install the necessary software to run our Play application. This means we need to install, at least, the Java runtime. We 

```bash
sudo apt-get update && sudo apt upgrade
sudo apt-get install openjdk-17-jdk-headless unzip
```