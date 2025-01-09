# Managing our database dependencies

If we want to use a database in our Play application, we need to add the necessary dependencies to our project. In this section, we'll learn how to add the necessary dependencies to our project to use a MySQL database.

## Adding the MySQL dependency

To use a MySQL database in our Play application, we need to add the MySQL connector dependency to our project. We can do this by adding the following dependency to our `build.sbt` file:

```scala
libraryDependencies ++= Seq(
      // --- other dependencies ---
      "mysql" % "mysql-connector-java" % "8.0.33" % "runtime",
      // --- other dependencies ---
    ),
```

Note that we don't require the MySQL connector to compile our application, so we added the dependency with the `runtime` scope. This means that the dependency will be available at runtime, but it won't be included in the compilation classpath. This dependency will provide the necessary classes to connect to a MySQL database.

## Configuring the database connection

To connect to a MySQL database, we need to configure the database connection in our `conf/application.conf` file. We need to provide the URL, username, and password to connect to the database. We can do this by adding the following configuration to our `conf/application.conf` file:

```hocon
db {
  default.driver=com.mysql.cj.jdbc.Driver
  default.url="jdbc:mysql://root:root@localhost/agenda"
  default.username="root"
  default.password="root"
  # Provided for JPA access
  default.jndiName=DefaultDS
}
```

In this configuration, we are using the `com.mysql.cj.jdbc.Driver` driver to connect to the MySQL database. We are connecting to the `agenda` database running on `localhost` with the username `root` and password `root`. You should replace these values with the appropriate values for your MySQL database (the ones you set up in the previous steps).

## Testing the database connection

Now that we have added the MySQL dependency and configured the database connection, we can run our Play application. Start your application and try to add some data to the database! Does it work? What happens if you restart the application? Do you lose the data you added?