# Terraform modules

Terraform modules are reusable and shareable components that group together related resources, simplifying the management of infrastructure. A module in Terraform is essentially a container for multiple resources that are used together. They can be called and used in other Terraform configurations, allowing for efficient, repeatable infrastructure setups. By using modules, you can organize your code, avoid repetition, and make your infrastructure more maintainable and scalable.

For our solution I develop five main module

  - [terraform-aws-eks](./terraform-aws-eks/README.md)
  - [terraform-aws-eks-addons](./terraform-aws-eks-addons/README.md)
  - [terraform-aws-eks-iam-policy](./terraform-aws-iam-policy/README.md)
  - [terraform-aws-eks-iam-role](./terraform-aws-iam-role/README.md)
  - [terraform-aws-eks-kms](./terraform-aws-kms/README.md)
  - [terraform-aws-eks-route53-record](./terraform-aws-route53-record/README.md)
  - [terraform-aws-eks-vpc](./terraform-aws-vpc/README.md)

I will briefly explain each one, further information may be found inside of them.

## Table of Contents
- [Terraform modules](#terraform-modules)
  - [Table of Contents](#table-of-contents)
  - [General configuration](#general-configuration)
  - [The modules](#the-modules)
    - [terraform-aws-eks](#terraform-aws-eks)
    - [terraform-aws-eks-addons](#terraform-aws-eks-addons)
    - [terraform-aws-iam-policy](#terraform-aws-iam-policy)
    - [terraform-aws-iam-role](#terraform-aws-iam-role)
    - [terraform-aws-kms](#terraform-aws-kms)
    - [terraform-aws-route53-record](#terraform-aws-route53-record)
    - [terraform-aws-vpc](#terraform-aws-vpc)

## General configuration

All the modules share some structure, even though each one has their own content the common files are:

  - versions.tf: Here I define restrictions regarding the version of Terraform to be used and the providers version too.
  - variables.tf: Here I defined the variables needed by the modules to work, trying to defined them as best as posible (name, description, type and default values)
  - README.md: General description and information of the module and a small example of usage.
  - outputs.tf: Definition of all the resources inforamtion I think is relevant to be showned as result of the implementation.
  - data.tf: Here I stored or process extra information needed by the module.

## The modules

### terraform-aws-eks

This is quite a big module because it handles most of the resources related to a Kubernetes cluster, such as:

  - Security Groups (Master and workers)
  - Definition of templates for the implementation of workers
  - Management of users using IAM users as base.
  - Namespaces creation
  - Cluster roles definitions
  - Priority classes for specific services
  - Creation of the EKS cluster
  - Definition of the OIDC
  - Creation of ASG, node groups and launch configuration for the workers
  - Creation of service accounts
  - Policies and roles needed by the worker nodes
  - Deployment of helm charts that you need by default, i.e cluster-autoscaler

### terraform-aws-eks-addons

This modules helps you to handle and keep track of the addons of a Kubernets cluster implemented with EKS. It makes the task of maintainig the addons a little easier.

### terraform-aws-iam-policy

Given a map of key values, being the key the name of the policy and the value its content, this module can create several policies at the same time. In combination with the templatization of files it can be really powerfull at the moment of implementation.

### terraform-aws-iam-role

The IAM Role modules is in charge of exactly that, the creation of roles, but it also allowed you to add policies to those roles.

### terraform-aws-kms

This module intention is to facilitate KMS keys creation and handling.

### terraform-aws-route53-record

This module allows you to create record with different caracteristics.

### terraform-aws-vpc

VPC module takes care of the creation of the following resources:
  
  - VPC
  - Internet Gateway
  - Nat Gateway
  - Elastic IPs
  - Public and private subnets
  - Public and private routes
  - NAcls
  - Common rules for NAcls