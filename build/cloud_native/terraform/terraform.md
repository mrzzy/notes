# Terraform 
References [Terraform: Up &amp; Running](https://www.terraformupandrunning.com/).

## Intro
Terraform facilitates the provisioning  infrastructure using config file (infrastructure as code)

Why Terraform:
- automates the tedious task of manually fiddling with the cloud providers UI (_ahem AWS_)
- supports major cloud providers and on-prem clouds (ie OpenStack)
- config can be checked into version control
- manage multi cloud deployments from one place:


```terraform
# use AWS EC2 for compute
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  # ....
}

# use GCP for DNS
resource "google_dns_record_set" "a" {
  name         = "demo.google-example.com"
  # .....
}
```

- declarative: declare expected state and terraform would figure how to get there

```terraform
resource "aws_instance" "example" {
  count         = 15 # from 10
  # terraform would automatically detect that we have 10 instances running
  # and create 5 more to reach the specified count.
}
```

> Multable infrastructure risks servers being configured slightly differently 
> resulting in unexpected bugs (ie configuration drift).
> Terraform allow us to deterministcally destroy &amp; reprovision infrastructure

### Install Terraform
Install terraform for `linux`:
```sh
TF_VERSION=\$(curl --silent "https://api.github.com/repos/hashicorp/terraform/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -c 2-)
wget https://releases.hashicorp.com/terraform/\${TF_VERSION}/terraform_\${TF_VERSION}_linux_amd64.zip
sudo unzip -d /usr/local/bin/ terraform_\${TF_VERSION}_linux_amd64.zip
rm terraform_\${TF_VERSION}_linux_amd64.zi
```

> Examples in this notes are tested with Terraform v0.12.24


### Workflow
Typical Workflow when working with Terraform:
1. Write a terraform spec `*.tf`* defining what what to deploy
2. Once only: `terraform init`
3. `terraform plan` to see what changes would be applied
4. `terraform apply` to apply the changes to cloud provider

#### In Detail
The workflow in detail  when using terraform:
- Write terraform deployment as `*.tf` files
- Init Terraform: pulls terraform cloud plugins (providers), required for new projects:
```sh
terraform init # pulls aws/gcp/azure provider based on *.tf files
```
- preview changes to be applied/view changes as a graph
```sh
terraform plan # show changes
# visualise changes as a graph
# requires graphviz for dot command
terraform graph | dot -Tpng > graph.png 
```
- apply changes to the cloud (AWS)
```sh
terraform apply
```
- destroy all changes applied by terraform
```sh
terraform destroy
```

### Gitops
Commit the `*.tf` files, add this to `.gitignore`
```gitignore
.terraform
*.tfstate
*.tfstate.backup
```
Now you share with your team, rollback with `git revert` etc.

## Quickstart: AWS
Working example of using Terraform to provision on AWS:
- setup AWS access
- deploy a simple server
- deploy a simple web server

### Setup AWS Access
Setup AWS Access for Terraform:
- create IAM user `terraform` with permissions:
  - AmazonEC2FullAccess, AmazonS3FullAccess AmazonDynamoDBFullAccess
  - AmazonRDSFullAccess,CloudWatchFullAccess, IAMFullAccess
- expose user credentials via env vars:
```sh
export AWS_ACCESS_KEY_ID=\$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=\$(aws configure get aws_secret_access_key)
```

### Deploy Simple Server
Deploy a simple server with Terraform:
- use `aws_instance` define an AWS EC2 instance

```terraform
# configure terraform to deploy on AWS in the us-east-2 region
provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "simple_server" {
  # server vm image: ubuntu 18.04 LTS
  ami           = "ami-0ca54d8a9af037f5b"
  instance_type = "t2.micro" # server vm resources
  # add arbitrary tags
  tags          = {
    Name    = "simple-server"
    Project = "learn-terraform"
  }
}
```

> The `ami` id might no longer exist and might need to be changed,
> different regions also use different AMIs :unamused:
> One solution to this could be using a data source to pull the AMI id

### Deploy Simple Web Server
Deploy a simple web server with Terraform:
- use a AWS security group to expose 

```terraform
# provider ...

# configure security groups for using security groups
# firewall - controfs traffic to the instance.
resource "aws_security_group" "simple_web_server_sg" {
  name = "simple-web-server-sg"

  # allow traffic from port 8080 in the internet to 
  # port 8080 in the instance.
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

- use `aws_instance` define an AWS EC2 instance:

```terraform
resource "aws_instance" "simple_web_server" {
  ami           = "ami-0ca54d8a9af037f5b"
  instance_type = "t2.micro" 
  tags          = {
    Name    = "simple-web-server"
    Project = "learn-terraform"
  }
  # reference other resources in the format <PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
  # here we configure the instance's security group by referencing it 
  vpc_security_group_ids = [ aws_security_group.simple_web_server_sg.id ]

  # shell script passed to instance on startup
  user_data     = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}
```

> Ping your `simple-web-server` with 
> ```
> curl http://<server-public-ip>:8080
> ```


### Autoscaling Web Server
Autoscaling Web Server on AWS with terraform is more involved and complex:
- define `aws_launch_configuration` to specify how instances are created
- define `aws_autoscaling_group` to define how instances are auto scaled
- define `aws_lb_target_group` and with instances in the autoscaling group
- create a `aws_lb` and `aws_lb_listener` point it at the target group using `aws_lb_listener_rule`

In Detail:
- define a data source to pull information (`subnet_id`s) about the the default `aws_vpc`

```terraform
# provider ... security group ...

# data source to pull info about default vpc
data "aws_vpc" "default" {
  default = true
}
# data source to pull subnet_ids in default vpc
data "aws_subnet_ids" "default_vpc" {
  vpc_id = data.aws_vpc.default.id
}
````

- define a `aws_launch_configuration` instance template:

```terraform
# define a launch configuration which specifies a template that 
# the autoscaling group would use to create new instances
resource "aws_launch_configuration" "autoscaling_web_server_template" {
  image_id        = "ami-0ca54d8a9af037f5b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.autoscaling_web_server_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}
```

- create a `aws_autoscaling_group` to autoscale instance

``` terraform
# define a autoscaling group that automatically scales instances by creating 
# or destroying based on some load metric (ie cpu load)
resource "aws_autoscaling_group" "autoscaling_web_server_asg" {
  launch_configuration = aws_launch_configuration.autoscaling_web_server_template.name
  vpc_zone_identifier = data.aws_subnet_ids.default_vpc.ids
  
  # configure instances in this autoscaling group to also be inside the target group
  target_group_arns = [aws_lb_target_group.autoscaling_targets.arn]

  # instance config
  min_size = 2
  max_size = 10

  # verbose tagging syntax only specific to aws_autoscaling_group
  tag {
    key                 = "Name"
    value               = "autoscaling-web-server"
    propagate_at_launch = true # copy tag to instances create by asg
  }

  tag {
    key                 = "Project"
    value               = "learn-terraform"
    propagate_at_launch = true
  }
}

```

- define a `aws_lb_target_group` containing all the autoscaled instances:

```terraform
# define target group
resource "aws_lb_target_group" "autoscaling_targets" {
  name     = "autoscaling-targets"
  port     = 8080 # port that target instances receive traffic
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

```

- deploy a `aws_lb` load balancer to load balance across multiple instances
    - packet flow:  Load Balancer -> Listener -> Listener rule -> Target Group

```terraform
# Security group for load balancer 
# required because AWS blocks all traffic (in and out) by default
resource "aws_security_group" "autoscaling_lb_sg" {
  name = "autoscaler-lb-sg"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0 # 0 - any port
    to_port     = 0
    protocol    = "-1" # any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# define load balancer to load balance over autoscaled instances in target group
resource "aws_lb" "autoscaling_lb" {
  name               = "autoscaling-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_vpc.ids
  security_groups    = [aws_security_group.autoscaling_lb_sg.id]
}

# define http listener for our load balancer
resource "aws_lb_listener" "autoscaling_lb_http" {
  load_balancer_arn = aws_lb.autoscaling_lb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# point the load balancer listener at the at the target group with a listener rule 
resource "aws_lb_listener_rule" "autoscaling_listener" {
  listener_arn = aws_lb_listener.autoscaling_lb_http.arn
  priority     = 100

  condition {
    path_pattern {
        values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.autoscaling_targets.arn
  }
}
```



## Types &amp; Variables
Terraform has variables with types to make your `*.tf` files confgurable without having to edit them directly.
```terraform
variable "ingress_port" {
  description = "Ingress port to expose through the firewall"
  type        = number
  default     = 80
}
```

### Types
Types:
- basic types (default: `any`):  `string, number, bool, object, any`
- collection types: `map, list, set, tuple`

> Collection variables can be configure to only store variables of a certain type. 
> (ie `map(string)`, `list(number)`

### Using Variables
Using variables in terraform:
- Specify variables with the `var.` prefix:
```terraform
#....
  ingress {
    from_port   = var.ingress_port
    to_port     = var.server_port
#...
```

- Interplotate them into strings with `"${var.<variable>}"`

#### Output Variables
Output variables can be used to show information about deployments without having
to go directly to the cloud provider:
```terraform
output "public_ip" {
  value       = aws_instance.simple_web_server.public_ip
  description = "The public IP address of the simple web server"
}
```
will show after `terraform apply`:
```
....
Outputs:

public_ip = 54.174.13.5
....

```

#### Local Variables
Local Variables are variables that are only visible inside the module it is defined in:
```
locals {
  http_port    = 80
}
```
Use `local.http_port` to access the value of the part

## Data Sources
Data Sources allow us to pull information from the cloud provider (with the `data.` prefix):
- Pull subnet ids for the default AWS VPC:
```terraform
# pull data about the default vpc
# pull subnet_ids from the default vpcs
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "vpc_default" {
  vpc_id = data.aws_vpc.default.id
}
```

Access subnet ids via `data.aws_subnet_ids.vpc_default.ids` 
- Pull the AWS AMI id that is available &amp; tagged `web` component:
```terraform
# Find the latest available AMI that is tagged with Component = web
data "aws_ami" "web" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Component"
    values = ["web"]
  }

  most_recent = true
}
```

Access AMI id via `data.ami.web.image_id`

## Terraform State &amp; Workspaces
Terraform stores state in `*.tfstate` files:
- do not check into VCS - `tfstate` file store credentials!
- configure terraform to store in a _backend_: typically cloud storage bucket (ie S3, GCS etc.)
- provides locking to prevent race condition when multiple users try to update at once

Backends:
- Store state on AWS S3, locking via dynamo DB 
- GCS for state and locking
- [more backends ...](https://www.terraform.io/docs/backends/types/index.html)

Workspaces isolate `tfstate` for different environments (ie `staging` and `production`):
- `terraform workspace show` show current workspace
- `terraform workspace new production` new workspace
- `terraform workspace select production` switch workspace


## Modules 
Modules in Terraform allow us to build reusable components (modules):
- each module is a folder of `*.tf` files.
- by convention each module has the the following files:
    - `variables.tf` - collects all the variables in the module, allowing for easy configuration. 
        Acts the module's inputs
    - `main.tf` - main terraform definitions
    - `outputs.tf` - collects all the `output{}` for the module


Use a module by sourcing it:
```terraform
module "autoscaling_web_server" {
  source = "path/to/module"
  # variables set in the module (should be in variables.tf)
  server_port = 80
}
```

Access outputs from the module via `module.<module name>.<output name>`


## State
Terraform tracks the current state of deployed infrastructure in `.tfstate` file:
- maps terraform resources to actual deployed cloud resources.
- contains generated credentials (if any).

> `.tfstate` is aunstable internal API and should not be depended on.
>  Use `terraform import` or `terraform state` to manipulate `.tfstate`.

#### Sharing State
Terraform from multiple users, `.tfstate` must be shared, presenting the following problems:
- all users need to be able access `.tfstate`
- `.tfstate` changes must be synchronized.
- credentials are in plaintext for people to steal from `.tfstate` files.

Solution: Use cloud buckets (ie AWS S3/GCP GCS) to store terraform state remotely:
- Shared storage ensures everyone has the can access `.tfstate`
- Locking before making changes makes sure changes are syncronized`.tfstate`
- Turnkey authentication with cloud provider to protect `.tfstate`

> AWS Specific: S3 state backend does not support locking,
> so we also need a Dynamo DB table to lock (omitted in notes.)

#### Configuring Remote State

Example on AWS:
1.  Create bucket (&amp; optional: Dynamo DB table for locking):
```terraform
# create S3 bucket to store terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # See full revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default to protect credentials
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# ... optional: Dynamo DB table for locking.
```

2. `terraform apply` to create infra for shared state.
3. Configure terraform to use remote state:

```terraform
terraform {
  backend "s3" {
    # point to bucket
    bucket         = "terraform-up-and-running-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"

    # optional: dynamodb_table for locking ...
  }
}
```

4. Sync local state to remote state with  `terraform init`
5. Profit.
