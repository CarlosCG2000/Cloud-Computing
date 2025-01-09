# Making our deployment resilient

As me mentioned earlier, we would like to provide a seamless experience when we are scaling our application. This means that we need to make sure our users are not aware of any change we make to our deployment architecture: adding new instances, removing old ones, using a different region or availability zone, using a different instance type, etc. All these are internal details that should not be visible to our users.

## Introduction to load balancing

One of the most common ways to make our deployment resilient is by using a load balancer. A load balancer is a layer (hardware or software) that distributes network or application traffic across a cluster of servers. Load balancers are used to increase capacity (concurrent users) and reliability of applications. They improve the overall performance of applications by distributing the workload across multiple servers, ensuring that no single server is overwhelmed.

AWS provides a service called Elastic Load Balancing (ELB) that automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances. It can handle the varying load of your application traffic in a single Availability Zone or across multiple Availability Zones.

## Creating a load balancer

Let's create a load balancer for our application. To do this, we need to go to the AWS console and click on the `EC2` service. Once there, we need to click on the `Load Balancers` section.

Once there, we need to click on the `Create Load Balancer` button. This will open a wizard that will guide us through the process of creating a new load balancer. At the time of writing, there are three types of load balancers available: Application Load Balancer, Network Load Balancer, and Gateway Load Balancer. The previous generation load balancers (Classic Load Balancer) are available too.bWe are not going to deep dive into the differences between them, but we are going to use the Application Load Balancer.

Pick the Application Load Balancer and click on the `Create` button. This will open a new wizard where we need to configure the load balancer. We need to provide a name for the load balancer, a scheme (internet-facing), an IP address type (IPv4). In the network settings section, select our unique VPC and all the availabilty zones available.

In the security group settings, we need to create a new security group that allows traffic on port 80 from anywhere.

In the Listeners and routing section, we need to configure the listener. A listener is a process that checks for connection requests using the port and protocol you configure. We need to configure the listener to listen on port 80 and define the default action for routing requests.

We will need to create a new target group. A target group is used to route requests to one or more registered targets. We need to provide a name for the target group, a protocol (HTTP), a port (80), and the target type (instance). We need to register the instances we want to route traffic to. The target group also specifies the health checks that need to be performed on the targets to determine their health status.

Don't forget to register the instances we want to route traffic to before hitting the `Create Target Group` button.

## Health checks and Play

The target group we created will perform health checks on the instances we registered. The health checks are used to determine the health status of the instances. If an instance is unhealthy, the load balancer will stop routing traffic to it. ALB health checks don't send a Host header in the request, so we need to make sure our Play application is configured to accept requests without a Host header. This is a bit unusual, as the HTTP specification requires the Host header to be present in all requests.

In order to configure a proper health endpoint in our Play application, we need to define a new `anyhost` tag, which can be used to exclude one or more routes from the `AllowedHostsFilter`.

```hocon
play.filters.hosts.routeModifiers.whiteList = [anyhost]
```

Now, we can configure our health check route in our `conf/routes` file:

```hocon
+anyhost
GET     /health                     controllers.HealthCheckController.check()
```

If we run our application and try to hit the `/health` endpoint with an empty `Host` header, we should get a `200 OK` response.

```bash
> curl -I -H 'Host:' http://localhost:9000/health
HTTP/1.1 200 OK
Referrer-Policy: origin-when-cross-origin, strict-origin-when-cross-origin
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Permitted-Cross-Domain-Policies: master-only
content-length: 7
Content-Type: text/plain; charset=utf-8
Date: Sat, 14 Dec 2024 23:30:57 GMT
```

However, if we hit the `/persons` endpoint, we should get a `400` error back

```bash
curl -I -H 'Host:' http://localhost:9000/persons
HTTP/1.1 400 Bad Request
Referrer-Policy: origin-when-cross-origin, strict-origin-when-cross-origin
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Permitted-Cross-Domain-Policies: master-only
content-length: 1166
Content-Type: text/html; charset=utf-8
Date: Sat, 14 Dec 2024 23:32:03 GMT
```

## Validating our load balancer

At this point, our system is ready! If an instance becomes unhealthy, the load balancer will stop routing traffic to it. If we add more instances, the load balancer will automatically start routing traffic to them. We can now scale our application horizontally and vertically without our users noticing any change. Let's try to hit the load balancer's DNS name and see if we get a response back.