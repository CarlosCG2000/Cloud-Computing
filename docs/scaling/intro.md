# Scale and fault-tolerance

At this point we have our Play application running on an EC2 instance, connected to a MySQL database runnning as an RDS instance. But now we want to make sure our application can handle more traffic and that it's fault-tolerant.

What happens if our application crashes? What happens if the instance is restarted? How can we make sure our application is always running and can handle more traffic? 

During the next sections we will answer all these questions, and more