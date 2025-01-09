# Running the Play application

We are ready to run our application for the first time. Go into your application folder and run the following command:

```bash
sudo ./bin/agenda -Dhttp.port=80 -Dplay.http.secret.key="9gx9[jnPE>zTDmzAC^p<ETbLBsnljKEqhT1CSDDDYubCw?4^agPJX:2Rz1k2?h<AaUB"
```

A couple of things to note here which are particularly tight to the Play framework:

If you look at your `conf/application.conf` file, you will find a configuration section that looks like this:

```hocon
# Allowed hosts
play.filters.hosts {
  # Allow requests to example.com, its subdomains, and localhost:9000.
  allowed = [".amazonaws.com", "localhost:9000"]
}
```
when you deploy a Play application you need to properly configure the `play.filters.hosts.allowed` configuration to allow requests from the domain you are deploying the application to. In this case, we are deploying the application to an AWS instance, so we need to allow requests from the AWS domain.

The `play.http.secret.key` configuration is used to signing session cookies and CSRF tokens and built in encryption utilities. It is important to keep this value secret and unique for each application. You can generate a new secret key by running the following command:

```bash
sbt playGenerateSecret
```


The application should now be running and accessible via the instance's public IP address. What has happened? Did it work for your? In case it didn't, what do think we need to do to fix it?

## Fixing our deployment

As you have already probably noticed, the application is not accessible from the outside world. This is because the Play application is running on port 80, but the instance's security group is not allowing traffic on that port.

Go back to the AWS console and click on the `Security Groups` link. Select the security group associated with the instance and click on the `Edit inbound rules` button. Add a new rule that allows traffic on port 80 from anywhere.

What would happen if we restart the instance? Would the application still be running? What do you think we need to do to make sure the application is always running? Let's try to figure it out together.

## Always running

As we mentioned earlier, the application will stop running if the instance is restarted. To make sure the application is always running, we need to use a process manager like `systemd`.

In our AWS instance, we need to create a new service file in the `/etc/systemd/system` directory. Let's create a new file called `agenda.service`:

```bash
sudo vim /etc/systemd/system/agenda.service
```

with the following content:

```bash

[Unit]
Description="Agenda Play application"

[Service]
WorkingDirectory=/home/ubuntu/agenda-1.0-SNAPSHOT
ExecStart=
ExecStop=/bin/kill -TERM $MAINPID
Type=simple
Restart=always

[Install]
WantedBy=multi-user.target
```

Now we need to reload the systemd daemon and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable agenda
```

What would happen if you kill the process? Or if the application crashes? What would happen if the instance is restarted? You can try to simulate these scenarios and see what happens.

## Checking the status of the service

You can check the status of the service by running:

```bash
sudo systemctl status agenda
```

and you can check the logs of the application by running:

```bash
sudo journalctl -u agenda
```

The output of the previous command should look something similar to:

```bash
ubuntu@ip-172-31-4-87:~/agenda-1.0-SNAPSHOT$ journalctl -u agenda -f
Dec 13 18:17:56 ip-172-31-4-87 agenda[2438]: INFO  p.c.s.PekkoHttpServer - Running provided shutdown stop hooks
Dec 13 18:17:56 ip-172-31-4-87 systemd[1]: agenda.service: Main process exited, code=exited, status=143/n/a
Dec 13 18:17:56 ip-172-31-4-87 systemd[1]: agenda.service: Failed with result 'exit-code'.
Dec 13 18:17:56 ip-172-31-4-87 systemd[1]: Stopped agenda.service - "Agenda Play application".
Dec 13 18:17:56 ip-172-31-4-87 systemd[1]: agenda.service: Consumed 18.591s CPU time, 63.6M memory peak, 0B memory swap peak.
Dec 13 18:18:04 ip-172-31-4-87 systemd[1]: Started agenda.service - "Agenda Play application".
Dec 13 18:18:06 ip-172-31-4-87 agenda[2558]: INFO  p.a.h.HttpErrorHandlerExceptions - Registering exception handler: guice-provision-exception-handler
Dec 13 18:18:07 ip-172-31-4-87 agenda[2558]: INFO  p.a.d.DefaultDBApi - Database [default] initialized
Dec 13 18:18:07 ip-172-31-4-87 agenda[2558]: INFO  p.a.d.HikariCPConnectionPool - Creating Pool for datasource 'default'
Dec 13 18:18:07 ip-172-31-4-87 agenda[2558]: INFO  p.a.d.HikariCPConnectionPool - datasource [default] bound to JNDI as DefaultDS
Dec 13 18:18:12 ip-172-31-4-87 agenda[2558]: INFO  play.api.Play - Application started (Prod) (no global state)
Dec 13 18:18:12 ip-172-31-4-87 agenda[2558]: INFO  p.c.s.PekkoHttpServer - Listening for HTTP on /[0:0:0:0:0:0:0:0]:80
```