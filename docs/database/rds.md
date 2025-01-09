# Running a relational database in production

We started our journey by running our small Play application using an in-memory database. This was a great way to get started and get our application up and running quickly. However, in a real-world scenario, we would want to use a relational database to store our data. In this section, we'll learn how to run a relational database in production.

In order to get familiar with the changes that need to be done, in the previous section we installed a MySQL database in our development environment, and connected our Play application to it. During the following sections, we will learn how to run a MySQL database in production using our Cloud provider.

## Managed services

You could think that installing MySQL in a production environment is as simple as running `sudo apt-get install mysql-server`. However, there are a few things to consider when running a database in production. We need to make sure that the database is secure, that it's properly configured, and that it's backed up regularly. This usually involves having certain level of expertise in running and maintaining a database.

Fortunately, most Cloud providers offer managed database services that take care of all these things for us. In this section, we'll learn how to run a MySQL database in production using the managed database service provided by our Cloud provider: [Amazon RDS](https://aws.amazon.com/es/rds/).

## Spawn a new RDS instance

The first step is to create a new RDS instance. To do this, we need to go to the AWS console and click on the `RDS` service. Once there, we need to click on the `Create database` button. This will open a wizard that will guide us through the process of creating a new RDS instance.

Most of the settings are self-explanatory. We need to select the database engine we want to use (MySQL), the version of the engine, and the instance class (make sure you select the Free Tier here). We can leave the default settings for now. We need to provide a username and password to connect to the database. Make sure to store these credentials in a safe place.

## Connectivity from our Play application

In the previous wizard, we also need to configure the connectivity settings. We need to make sure that our Play application can connect to the database. We need to provide the security group that the RDS instance will use. Make sure to configure a security group that allows traffic from the instance where the Play application is running.

## Connecting to the RDS instance

Once we have finished the wizard and the database is up and running (it takes a while), we can connect to the RDS instance using a MySQL client. We can use the `mysql` command line client to connect to the database. The connection string will look something like this:

```bash
mysql -h <rds-endpoint> -u <username> -p
```

If everything went well, we should be able to connect to the database and start running queries. Grab the contents of the `conf/sql/tables.sql` and run in the session we have just established:

```sql
create database if not exists agenda default character set utf8 collate utf8_general_ci;
use agenda;
create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );
```

We are ready to connect our Play application to this very new database!
