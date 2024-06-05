# DocuSketch Challenge

This project contains all the reosurces needed to fullfil the challenge provided by DocuSketch.

This main page will try to cover the general aspects of each section, but in each one you will find links to the details of them. 

## Table of Contents
- [DocuSketch Challenge](#docusketch-challenge)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [My approach](#my-approach)
    - [Infrastructure](#infrastructure)
    - [Application](#application)
    - [App deployment](#app-deployment)
    - [CI/CD](#cicd)
  - [Tools](#tools)
  - [Improvements](#improvements)


## Introduction

The challenge request us to create a whole environment using different technologies, the goal is to cover different aspects of a software solution making use of diverse technologies. We need to cover:

  - Infrastructure creation: Networking resources, Kubernetes cluster and extra resources. For the creation we were requested to use Terraform.
  - Application: It does not need to be a complex one, just something to help us test the whole configuration.
  - Application Deployment on Kubernetes: We need to create all the manifests needed to a successful deployment of our app into Kubernetes.
  - Documentation: We need to provide as much as possible to make our decisions clear to the evaluators. This is the "why" for this document.

## My approach

This section is intended to give a general view on my decisions regarding how to fullfil the task. I also provide links to more detailed documents on each technologie.

### Infrastructure

First of all we need to define where to place all our resources. I decided to use `AWS Cloud` because it is the one I'm feeling more confortable with. Services used here were:
  
  - IAM: users management, policies, roles.
  - EKS: to handle the Kubernetes cluster (including addons).
  - VPC: to manage networking components (vpcs, routing tables, internet gateways, security groups, nat gateways, subnets, )
  - KMS: encription keys management.
  - EC2: to provide Kubernetes nodes using node groups, load balancers, key pairs
  - Route 53: to manage domains and accesibility to the services in the cluster.

For the implementation and deployment of these resources I used Terraform as it was require. For the sake of flexibility and reutilization of resources, I went for a module structure to define them.

This modules structure means that I created several Terraform modules to handle resources, more details over my modules here: [Terraform Modules](./tf_modules/README.md). Summarizing I created 5 main modules:

  - terraform-aws-eks
  - terraform-aws-eks-addons
  - terraform-aws-eks-iam-policy
  - terraform-aws-eks-iam-role
  - terraform-aws-eks-vpc

All this modules are stored in `./tf_modules`. Rather using this approach it will be better to store them in the Terraform cloud registry, but we will cover this in the [improvements](#improvements) section.

For the actual implementation of all the resources I created a new directory `./tf_implementation`, here I structured the calls to the modules generalizing by main service (networking, eks, extras). The main idea under this structure is to concentrate all the similar resources in the same place. So, for example in the same directory I have eks module implementation and eks-addons. The details on these implemetantions is here [Terraform Modules](./tf_implementation/README.md)

### Application

For the application itself I used a simple nodejs page that contains a simple "Hello world" message and a few other values to demostrate the flexibility that my implementation provides. I created a directory (./services) to contain all the services, but right now I just have the `frontend` service.The details on the application like code and docker implementation is here [Services](./services/README.md).


### App deployment

To manage the configuration of the services, this means Kubernetes manifests I select [Helm](https://helm.sh/). Helm is a package manager for Kubernetes. It helps me define, install, and manage the application on Kubernetes. This simplifies the process of sharing and deploying applications across different environments.
The benefit to use Helm is also that we can use it (and I did) to install extra tools in our environemnt (like ingress-controller and cluster-autoscaler).

But going back to our application, all the manifests were defined as templates, "Why?" it will be the first question to come up. The reason is because I used an extra layer on top of helm, I used helmfile. Helmfile allowed me to manage multiple environments using the same manifest. The scope of this challenge just covers the definition of one environment, but I liked to show the flexibility that this technology provides. More details on helm and helmfile here [Services](./services/README.md)

### CI/CD

For the CI/CD section my approach was to implement a Github action system due to the usage of github to store the code [ds_challenge](https://github.com/DdeDamian/ds_challenge). The solution is based in two main sections, one to build and push to the gihub repo the service image and the other section is to deploy the new code into Kubernetes. All the details on the action functionality is here [workflows](./.github/workflows/README.md)

## Tools

As I mention earlier, in ach section you have more details on how all the sections were created and implemented. But I think that is nice to have a brief summary on all the tools used allong the project.

  - Cloud provides: [AWS](https://aws.amazon.com/)
  - IaC: [Terraform](https://www.terraform.io/)
  - CI/CD: [Github actions](https://github.com/features/actions)
  - Kubernetes management: [helm](https://helm.sh/) and [helmfile](https://github.com/helmfile/helmfile) (manifests), [Lens](https://k8slens.dev/) (cluster visualization)
  - Secrets management: [sops](https://github.com/getsops/sops) (working togheter with KMS service)  

## Improvements

Some key points that I think are good as improvements (but maybe exceded the scope of this task) are:

  - Terraform Cloud: TFC provide us with several benefits such as terraform modules registry (storage, versioning) and workspaces (state storage, costs calculation and CI/CD for infrastructure).
  - I used a root account for AWS, but this is not recommended and I suggest to use an Organizational Units system to isolate environments and specify accounts usage (like users handling).