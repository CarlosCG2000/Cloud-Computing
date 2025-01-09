# Storing our data

The database is a crucial part of any application. It's where we store our data, and it's where we retrieve it from. In this section, we'll learn how to provision a production-ready database for our Play application.

The Agenda application we are using in this guide is a simple application that stores and retrieved data from a database using JPA. We'll continue using this application to demonstrate how to provision a database.

## The default database

Until now, we've been using an in-memory database for our application. This is fine for development, but it's not suitable for production. We need a database that can store our data permanently. What would happen if our application crashed? Or if we needed to scale it up? We would lose all our data.