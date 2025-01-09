# Running our application locally

Since you have probably already set up your development environment during the first part of this subject, getting the Agenda application running in your local environment should be a no brainer for you. If you haven't done that yet, please refer to the [Setting up your development environment](https://www.playframework.com/documentation/3.0.x/Requirements) official docs.

Once you are ready, execute the application using the following command:

```bash
cd apps/agenda
sbt run
```

The output should look like this:

```bash
➜  agenda git:(master) ✗ sbt run  
[info] welcome to sbt 1.10.2 (Eclipse Adoptium Java 17.0.13)
[info] loading settings for project agenda-build from plugins.sbt ...
[info] loading project definition from /Users/migue/development/sourcecode/migue/cloud-native/applications/agenda/project
[info] loading settings for project root from build.sbt ...
[info]   __              __
[info]   \ \     ____   / /____ _ __  __
[info]    \ \   / __ \ / // __ `// / / /
[info]    / /  / /_/ // // /_/ // /_/ /
[info]   /_/  / .___//_/ \__,_/ \__, /
[info]       /_/               /____/
[info] 
[info] Version 3.0.6 running Java 17.0.13
[info] 
[info] Play is run entirely by the community. Please consider contributing and/or donating:
[info] https://www.playframework.com/sponsors
[info] 

--- (Running the application, auto-reloading is enabled) ---

INFO  p.c.s.PekkoHttpServer - Listening for HTTP on /[0:0:0:0:0:0:0:0]:9000

(Server started, use Enter to stop and go back to the console...)
```

Go to your browser and open the following URL: [http://localhost:9000](http://localhost:9000). Does this work for you? If it does, congratulations! You have your application running locally.