# Deploy automation with Terraform

In the previous section, we learned how to create an AMI with Packer. Now, we are going to learn how to deploy our application to AWS using Terraform. The idea is to create a fully automated deployment process, where we can create the infrastructure and deploy our application with a single command.

The architecture is the same as the one we used during the whole course, the only difference is that we are going to build a repeatable and automated process to deploy it. Please, note that this application uses an in-memory database, so it is not suitable for production. Automating the generation of an RDS instance and connecting it to the application is left as an exercise that needs to be done by the students as part of the final project that needs to be delivered at the end of the course.

## Installing Terraform

You can find here how to install Terraform in your OS: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Creating a Terraform script

Terraform scripts are written in HCL (https://github.com/hashicorp/hcl). Similar to what we did in the Packer section, let's start backwards, defining a fully functional Terraform script and then explaining each part.

```hcl
variable "ami_id" {
  type    = string
  default = ""
}

provider "aws" {
  region = "eu-south-2"
  skip_region_validation = true
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
 }
}

resource "aws_security_group" "instance" {
  name = "agenda"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.agenda_alb.id]
  }
}

resource "aws_launch_template" "agenda" {
  name          = "agenda-template"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name = "mimo-cloud-teacher"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.instance.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "agenda-app"
    }
  }
}

resource "aws_autoscaling_group" "agenda_asg" {
  launch_template {
    id      = aws_launch_template.agenda.id
  }
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.agenda_tg.arn]
  health_check_type = "ELB"

  min_size = 2
  desired_capacity = 3
  max_size = 6

  tag {
    key = "Name"
    value = "agenda-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "agenda_lb" {
  name = "agenda"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.agenda_alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.agenda_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Page Not Found"
      status_code = 404
    }
  }
}

resource "aws_security_group" "agenda_alb" {
  name = "agenda-alb"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "agenda_tg" {
  name = "agenda-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/health"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.agenda_tg.arn
  }
}

output "agenda_alb_dns_name" {
  value = aws_lb.agenda_lb
  description = "Domain name of the Agenda App ALB"
}
```

## Understanding the Terraform script

### Providers

The first part of the script defines the provider we are going to use. In this case, we are using AWS, so we define the provider as follows:

```hcl
provider "aws" {
  region = "eu-south-2"
  skip_region_validation = true
}
```

Terraform has different providers implementations covering a wide range of cloud providers and services. You can find more information about the providers in the documentation: [Terraform Providers](https://registry.terraform.io/browse/providers)

### Defining the instances

Now that we have the provider defined, we can start defining the different resources we need to create. The first one is the security group for the instances and the instances themselves.

```hcl
resource "aws_security_group" "instance" {
  name = "agenda"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.agenda_alb.id]
  }
}

resource "aws_launch_template" "agenda" {
  name          = "agenda-template"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name = "mimo-cloud-teacher"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.instance.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "agenda-app"
    }
  }
}

resource "aws_autoscaling_group" "agenda_asg" {
  launch_template {
    id      = aws_launch_template.agenda.id
  }
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.agenda_tg.arn]
  health_check_type = "ELB"

  min_size = 2
  desired_capacity = 3
  max_size = 6

  tag {
    key = "Name"
    value = "agenda-asg"
    propagate_at_launch = true
  }
}
```

We are basically defining the security group for the instances, the launch template, and the autoscaling group. The autoscaling group will create instances based on the launch template and will register them in. This way, we can have a dynamic number of instances running our application.

As you can see, this is the same architecture we manually created in the previous sections. The difference is that now we are automating the process, being able to have a fully functional envrironment using a repeatable and less error-prone process.

### Creating the load balancer

Now that we have the instances, we need to create a load balancer to distribute the traffic among them. The following code creates the load balancer, the target group, and the listener rules.

```hcl
resource "aws_lb" "agenda_lb" {
  name = "agenda"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.agenda_alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.agenda_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Page Not Found"
      status_code = 404
    }
  }
}

resource "aws_security_group" "agenda_alb" {
  name = "agenda-alb"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "agenda_tg" {
  name = "agenda-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/health"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.agenda_tg.arn
  }
}
```

Again, we are creating the same architecture we manually created in the previous sections. The load balancer will distribute the traffic among the instances created by the autoscaling group, and every time a new instance is created or destroyed, the load balancer will automatically adjust the traffic distribution.

### Outputs

Finally, we define the outputs of the script. In this case, we are going to output the DNS name of the load balancer, so we can access the application.

```hcl
output "agenda_alb_dns_name" {
  value = aws_lb.agenda_lb
  description = "Domain name of the Agenda App ALB"
}
```

## Executing the Terraform script

The first thing we need to do is to init the Terraform script. From the deploy `folder`, run:

```bash
terraform init .
```

It will download the required providers and configure the environment to run the script.

You can validate the script with:

```bash
terraform validate
```

that will validate the syntax of the script. You should see something like:

```bash
Success! The configuration is valid.
```

Before we actually run the build process, note that we need to provide the AWS credentials to Terraform. You can do it by setting the environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
```

Now, we can see the plan of the script with:

```bash
terraform plan -var 'ami_id=<your-ami-id>'
```

This will show you the resources that are going to be created, updated, or destroyed. Note this is a dry-run, and no resources will be created or updated. The output should be something like:

```bash
deploy git:(main) ✗ terraform plan
data.aws_vpc.default: Reading...
data.aws_vpc.default: Read complete after 5s [id=vpc-0f5918a8441f43e9d]
data.aws_subnets.default: Reading...
data.aws_subnets.default: Read complete after 0s [id=eu-south-2]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_autoscaling_group.agenda_asg will be created
  + resource "aws_autoscaling_group" "agenda_asg" {
      + arn                              = (known after apply)
      + availability_zones               = (known after apply)
      + default_cooldown                 = (known after apply)
      + desired_capacity                 = 3
      + force_delete                     = false
      + force_delete_warm_pool           = false
      + health_check_grace_period        = 300
      + health_check_type                = "ELB"
      + id                               = (known after apply)
      + ignore_failed_scaling_activities = false
      + load_balancers                   = (known after apply)
      + max_size                         = 6
      + metrics_granularity              = "1Minute"
      + min_size                         = 2
      + name                             = (known after apply)
      + name_prefix                      = (known after apply)
      + predicted_capacity               = (known after apply)
      + protect_from_scale_in            = false
      + service_linked_role_arn          = (known after apply)
      + target_group_arns                = (known after apply)
      + vpc_zone_identifier              = [
          + "subnet-050010bfc645b3a2e",
          + "subnet-055234c6df6254488",
          + "subnet-0be41289b68a0f06d",
        ]
      + wait_for_capacity_timeout        = "10m"
      + warm_pool_size                   = (known after apply)

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = (known after apply)
        }

      + mixed_instances_policy (known after apply)

      + tag {
          + key                 = "Name"
          + propagate_at_launch = true
          + value               = "agenda-asg"
        }

      + traffic_source (known after apply)
    }

  # aws_launch_template.agenda will be created
  + resource "aws_launch_template" "agenda" {
      + arn             = (known after apply)
      + default_version = (known after apply)
      + id              = (known after apply)
      + instance_type   = "t3.micro"
      + key_name        = "mimo-cloud-teacher"
      + latest_version  = (known after apply)
      + name            = "agenda-template"
      + name_prefix     = (known after apply)
      + tags_all        = (known after apply)
        # (1 unchanged attribute hidden)

      + block_device_mappings {
          + device_name = "/dev/sda1"

          + ebs {
              + iops        = (known after apply)
              + throughput  = (known after apply)
              + volume_size = 20
              + volume_type = "gp2"
            }
        }

      + metadata_options (known after apply)

      + network_interfaces {
          + associate_public_ip_address = "true"
          + security_groups             = (known after apply)
        }

      + tag_specifications {
          + resource_type = "instance"
          + tags          = {
              + "Name" = "agenda-app"
            }
        }
    }

  # aws_lb.agenda_lb will be created
  + resource "aws_lb" "agenda_lb" {
      + arn                                                          = (known after apply)
      + arn_suffix                                                   = (known after apply)
      + client_keep_alive                                            = 3600
      + desync_mitigation_mode                                       = "defensive"
      + dns_name                                                     = (known after apply)
      + drop_invalid_header_fields                                   = false
      + enable_deletion_protection                                   = false
      + enable_http2                                                 = true
      + enable_tls_version_and_cipher_suite_headers                  = false
      + enable_waf_fail_open                                         = false
      + enable_xff_client_port                                       = false
      + enforce_security_group_inbound_rules_on_private_link_traffic = (known after apply)
      + id                                                           = (known after apply)
      + idle_timeout                                                 = 60
      + internal                                                     = (known after apply)
      + ip_address_type                                              = (known after apply)
      + load_balancer_type                                           = "application"
      + name                                                         = "agenda"
      + name_prefix                                                  = (known after apply)
      + preserve_host_header                                         = false
      + security_groups                                              = (known after apply)
      + subnets                                                      = [
          + "subnet-050010bfc645b3a2e",
          + "subnet-055234c6df6254488",
          + "subnet-0be41289b68a0f06d",
        ]
      + tags_all                                                     = (known after apply)
      + vpc_id                                                       = (known after apply)
      + xff_header_processing_mode                                   = "append"
      + zone_id                                                      = (known after apply)

      + subnet_mapping (known after apply)
    }

  # aws_lb_listener.http will be created
  + resource "aws_lb_listener" "http" {
      + arn                      = (known after apply)
      + id                       = (known after apply)
      + load_balancer_arn        = (known after apply)
      + port                     = 80
      + protocol                 = "HTTP"
      + ssl_policy               = (known after apply)
      + tags_all                 = (known after apply)
      + tcp_idle_timeout_seconds = (known after apply)

      + default_action {
          + order = (known after apply)
          + type  = "fixed-response"

          + fixed_response {
              + content_type = "text/plain"
              + message_body = "Page Not Found"
              + status_code  = "404"
            }
        }

      + mutual_authentication (known after apply)
    }

  # aws_lb_listener_rule.asg will be created
  + resource "aws_lb_listener_rule" "asg" {
      + arn          = (known after apply)
      + id           = (known after apply)
      + listener_arn = (known after apply)
      + priority     = 100
      + tags_all     = (known after apply)

      + action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }

      + condition {
          + path_pattern {
              + values = [
                  + "*",
                ]
            }
        }
    }

  # aws_lb_target_group.agenda_tg will be created
  + resource "aws_lb_target_group" "agenda_tg" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + connection_termination             = (known after apply)
      + deregistration_delay               = "300"
      + id                                 = (known after apply)
      + ip_address_type                    = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancer_arns                 = (known after apply)
      + load_balancing_algorithm_type      = (known after apply)
      + load_balancing_anomaly_mitigation  = (known after apply)
      + load_balancing_cross_zone_enabled  = (known after apply)
      + name                               = "agenda-tg"
      + name_prefix                        = (known after apply)
      + port                               = 80
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags_all                           = (known after apply)
      + target_type                        = "instance"
      + vpc_id                             = "vpc-0f5918a8441f43e9d"

      + health_check {
          + enabled             = true
          + healthy_threshold   = 3
          + interval            = 15
          + matcher             = "200"
          + path                = "/health"
          + port                = "traffic-port"
          + protocol            = "HTTP"
          + timeout             = 5
          + unhealthy_threshold = 3
        }

      + stickiness (known after apply)

      + target_failover (known after apply)

      + target_group_health (known after apply)

      + target_health_state (known after apply)
    }

  # aws_security_group.agenda_alb will be created
  + resource "aws_security_group" "agenda_alb" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "agenda-alb"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = []
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 80
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "agenda"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + agenda_alb_dns_name = {
      + access_logs                                                  = []
      + arn                                                          = (known after apply)
      + arn_suffix                                                   = (known after apply)
      + client_keep_alive                                            = 3600
      + connection_logs                                              = []
      + customer_owned_ipv4_pool                                     = null
      + desync_mitigation_mode                                       = "defensive"
      + dns_name                                                     = (known after apply)
      + dns_record_client_routing_policy                             = null
      + drop_invalid_header_fields                                   = false
      + enable_cross_zone_load_balancing                             = null
      + enable_deletion_protection                                   = false
      + enable_http2                                                 = true
      + enable_tls_version_and_cipher_suite_headers                  = false
      + enable_waf_fail_open                                         = false
      + enable_xff_client_port                                       = false
      + enable_zonal_shift                                           = null
      + enforce_security_group_inbound_rules_on_private_link_traffic = (known after apply)
      + id                                                           = (known after apply)
      + idle_timeout                                                 = 60
      + internal                                                     = (known after apply)
      + ip_address_type                                              = (known after apply)
      + load_balancer_type                                           = "application"
      + name                                                         = "agenda"
      + name_prefix                                                  = (known after apply)
      + preserve_host_header                                         = false
      + security_groups                                              = (known after apply)
      + subnet_mapping                                               = (known after apply)
      + subnets                                                      = [
          + "subnet-050010bfc645b3a2e",
          + "subnet-055234c6df6254488",
          + "subnet-0be41289b68a0f06d",
        ]
      + tags                                                         = null
      + tags_all                                                     = (known after apply)
      + timeouts                                                     = null
      + vpc_id                                                       = (known after apply)
      + xff_header_processing_mode                                   = "append"
      + zone_id                                                      = (known after apply)
    }

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

If everything looks good, you can apply the script with:

```bash
terraform apply -var 'ami_id=<your-ami-id>'
```

This will show you the resources that are going to be created, updated, or destroyed. If everything looks good, type `yes` and hit enter. Terraform will start creating the resources.

Have you suceeded? Can you access the application?
