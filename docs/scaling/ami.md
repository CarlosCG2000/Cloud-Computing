# Making a snapshot of our setup

Now that we have our application fully configured and running on an EC2 instance, we can create an snapshot. This will allow us to create new instances with the same configuration as the one we have now. This is useful if we want to scale our application both horizontally and vertically. In both scenarios, we can create new instances based on the snapshot we are about to create.

## Building an Amazon Machine Image (AMI)

In AWS, these snapshots are called AMIs (Amazon Machine Image). They are a special type of virtual appliance that is used to create a virtual machine within the Amazon Elastic Compute Cloud (EC2). It serves as the basic unit of deployment for services delivered using EC2.

Creating an AMI is a simple process. We just need to go to the AWS console and click on the `EC2` service. Once there, we need to click on the `Instances` link. This will show us a list of all the instances we have running. We need to select the instance we want to create an AMI from and click on the `Actions` button. From the dropdown menu, we need to select the `Image and templates` option and then click on the `Create image` button.

You can find all your AMIs by clicking on the `AMIs` link in the `Images` section of the EC2 service.

## Spawning a new instance from the AMI

Once the AMI is created, we can spawn a new instance from it. To do this, we need to go to the AWS console and click on the `EC2` service. Once there, we need to click on the `Launch Instance` button. This will open a wizard that will guide us through the process of creating a new instance. This time, instead of selecting the latest Ubuntu Server LTS version, we need to select the `My AMIs` option. This will show us a list of all the AMIs we have created. We need to select the one we just created and follow the wizard to create a new instance (don't forget to use the free tier instance type).

Now we have a new instance running with the same configuration as the one we created the AMI. Now we can take more concurrent requests and serve more users, and we can do it in a matter of seconds! And not only that, we can also create new instances with the same configuration in different regions, making our application more resilient to failures.

## Open questions

How do we offer a seamless experience to our users when we are scaling our application? What do you think we need to do to make sure that our users don't notice that we are scaling our application? Let's try to figure it out together.

