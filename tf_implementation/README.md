# AWS resources implementation

Trying to keep some kind of order I tried to put the instantiation of all related resources together. In other words, all the resources related to the cluster in `eks`, network stuff in `networking` and the small pieces that are alone in `extra_resources`.

## Table of Contents

- [AWS resources implementation](#aws-resources-implementation)
  - [Table of Contents](#table-of-contents)
  - [General aspects](#general-aspects)
  - [Implementation](#implementation)
    - [locals.tf](#localstf)
  - [Extra implementation decisions](#extra-implementation-decisions)
    - [Ingress-controller](#ingress-controller)
    - [Certificates creation](#certificates-creation)
    - [Github key](#github-key)

## General aspects

All the terraform implementation directories shared some files, as the modules, not in its content but in the usage. This files are:

- versions.tf: containing similar information as the modules but in this case we are defining stricter values to avoid incompatibilities.
- variables.tf: general variables in this case we define the ones required by AWS provider to avoid warnings during run.
- README.md: Short description of the implementation and designing decision made.
- outputs.tf: actual content to be shown after the run. This files implements the outputs of the modules.
- main.tf: containing the providers definition and configuration.
- locals.tf: this is one of the most important ones, because here we define the values to use on the modules implementation. More details here [locals.tf](#localstf)
- data.tf: in case that we need some extra data like some values from a particular data source will be define here.

## Implementation

The approach I followed to implement the modules is using the workspaces that terraform provides. In this way we can define several workspaces matching different environments, and using the same module deploy "n" environments.
The way to define this workspaces and move around id:

```bash
# Create new workspace
terraform workspace new <environment-name>

# Change to a different workspace
terraform workspace select <environment-name>
```

The key for this approach to work is to have a well defined locals.tf file, I'll go a little deeper in the next section.

### locals.tf

As I mention it is important to have a well defined and used locals.tf to works with the different workspaces, but what this means?
The response it is more clear with an example:

Imagine that you need to maintain two different environments `development` and `production`. Obviously you will define both workspaces, but the locals,tf file needs to be prepared to handle them.

```hcl
locals{
  vpc_cidr = {
    development = "172.4.0.0/16"
    production  = "172.6.0.0/16"
  }
  public_subnets_cidrs = {
    development = ["172.4.2.0/24", "172.4.4.0/24", "172.4.6.0/24"]
    production  = ["172.6.2.0/24", "172.6.4.0/24", "172.6.6.0/24"]
  }

  private_subnets_cidrs = {
    development = ["172.4.3.0/24", "172.4.5.0/24", "172.4.7.0/24"]
    production  = ["172.6.3.0/24", "172.6.5.0/24", "172.6.7.0/24"]
  }
}
```

This is correctly define but it needs a special way to be called, so the implementation should look something like this:

```hcl
module "vpc" {
  source = "./tf_modules/terraform-aws-vpc/"

  # Network settings
  cidr           = local.vpc_cidr[terraform.workspace]
  public_subnet  = local.public_subnets_cidrs[terraform.workspace]
  private_subnet = local.private_subnets_cidrs[terraform.workspace]
}
```

As you may notice, we are referencing the content of each map using `terraform.workspace` this variable provided by terraform tells us in which workspace are we placed on, so the implementation automatically looks for the value define for that workspace/environment.

In our challenge we just have one workspace/env but I defined the locals using this approach to show the flexibility of the usage of modules and the easy that it is to define new environments.

## Extra implementation decisions

As part of the process of the resources creation I took a few ones that are not directly related to terraform code, but are needed for this approach to work.

### Ingress-controller

As part of the extra resources used for the fulfillment of the project and taking the advantage of use helm, I decided to use and ingress-controller to handle the access to the cluster's services. It was installed by hand and the instructions and variables definition are in the `helm` directory.
Something important to mention is that this ingress-controller is the one in charge of create and destroy the load balancers we are going to use to access the different services, through its configuration files we can define which certificate are we going to use for secure connections, subnets to use, etc.

### Certificates creation

The certificate used in the load balancer for the secure connection was requested by hand.

### Github key

In order to grant access to the github registry I needed to use a special token on each deployment I used, s in that way the deployment can download the image needed. To achieve this I created the following resource in the cluster

```yaml
kind: Secret
type: kubernetes.io/dockerconfigjson
apiVersion: v1
metadata:
  name: github-package-secret
  namespace: development
data:
  .dockerconfigjson: # Here we need to place the github token in base64
```

and to deploy it I run:
```bash
kubectl apply -f docker_config.yaml
```