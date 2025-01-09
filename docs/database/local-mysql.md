# Connecting to MySQL locally

Before we jump into building a production-ready database in our cloud provider, let's explore what it takes to connect to a MySQL database locally. This will help us understand the different configurations we need to set up in our application to connect to such a database.

## Setting up MySQL

The first thing we need to do is to install MySQL in our local environment. You can download MySQL from the [official website](https://dev.mysql.com/downloads/mysql/). Follow the instructions to install MySQL in your local environment.

If you are running macOS, you can use [Homebrew](https://brew.sh/) to install MySQL. Run the following command to install MySQL:

```bash
brew install mysql
```

If you are running Linux, you can use the package manager of your distribution to install MySQL. For example, in Ubuntu, you can run the following command:

```bash
sudo apt install mysql-server
```

Ensure that MySQL is running in your local environment.

```bash
sudo systemctl start mysql.service
```

## Configuring the user

You can use the `mysqladmin` command to configure the user you want to use to connect to the database. For the sake of this guide, we will use the `root` user. Run the following command to configure the `root` user:

```bash
mysqladmin -u root password 'root'
```

## Creating our database and schema

Now that we have configured the user, we can create a database that we will use in our Play application. The first thing we need to do is to connect to the MySQL server using the `mysql` command-line client. Run the following command to connect to the MySQL server:

```bash
mysql -u root -p
```

and introduce the password you set up in the previous step.

You should see a prompt where you can run SQL commands:

```shell
➜  agenda git:(master) ✗ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 9.0.1 Homebrew

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

The actual commands to create the database can be found in the [apps/agenda/conf/sql/tables.sql](apps/agenda/conf/sql/tables.sql)

```sql
create database if not exists agenda default character set utf8 collate utf8_general_ci;
use agenda;
create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );
```

Run the previous commands in the MySQL prompt to create the `agenda` database and our app's schema:

```shell
mysql> create database if not exists agenda default character set utf8 collate utf8_general_ci;
Query OK, 1 row affected, 2 warnings (0.00 sec)

mysql> use agenda;
Database changed
mysql> 
mysql> create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );
Query OK, 0 rows affected (0.00 sec)

mysql> 
```

At this point, our database is ready to be used in our Play application. Remember the values you used to create the database, as we will need them to configure the database connection in our Play application.