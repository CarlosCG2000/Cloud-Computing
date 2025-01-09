# Deploying the Play application
In order to deploy the Play application, we need to copy the application files to the instance. The application example we are using during this tutorial is a simple Play application located in the [apps/agenda](apps/agenda) directory.

Let's go ahead and build the application:

```bash
cd apps/agenda
sbt dist
```

This will create a zip file in the `target/universal` directory. Now we need to copy this file to the instance. We can use the `scp` command to do this:

```bash
scp -i /path/to/keypair.pem target/universal/agenda-1.0-SNAPSHOT.zip ubuntu@<instance-ip>:/home/ubuntu
```

Once the file is copied, we can connect to the instance and unzip the file:

```bash
ssh -i /path/to/keypair.pem ubuntu@<instance-ip>
unzip agenda-1.0-SNAPSHOT.zip
```