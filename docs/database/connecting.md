# Connecting to the RDS instance

This is identical to the previous section where we connected our application to a MySQL instance running on our local machine. The only difference is that now we are connecting to an RDS instance running on AWS.

## Updating the application configuration

Connect to the EC2 instance where the Play application is running and open the `conf/application.conf` file. Update the `db` section of this configuration file with the connection details of the RDS instance. The configuration should look something like this:

```hocon
db {
  default.driver=com.mysql.cj.jdbc.Driver
  default.url="jdbc:mysql://<your-rds-instance-dns>/agenda"
  default.username="<your-username>"
  default.password="<your-password>"
  # Provided for JPA access
  default.jndiName=DefaultDS
}
```

Please, make sure you use the values you have introduced during the creation of your RDS instance

## Testing the connection

