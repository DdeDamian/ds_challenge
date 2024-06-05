# Frontend Service

This micro-service created with nodejs is in charge of present us a small web page showing us a "Hello world" message along some other information to show the content of some variables from different sources.

- [Frontend Service](#frontend-service)
  - [Structure](#structure)
  - [Files break down](#files-break-down)
    - [Dockerfile](#dockerfile)
    - [./helm/.sops.yaml](#helmsopsyaml)
    - [vars](#vars)
      - [./helm/vars/values.yaml](#helmvarsvaluesyaml)
      - [./helm/vars//values.yaml](#helmvarsvaluesyaml-1)
      - [./helm/vars//secrets.yaml](#helmvarssecretsyaml)
    - [Templates](#templates)

## Structure

The service is structure to organize all its content in a proper way, this is a brief look to it:

```bash
.
├── config.json                     <-- Config file of the service itself
├── Dockerfile                      <-- Dockerfile from which the image will be created
├── helm                             
│   ├── Chart.yaml                  <-- Helm chart definition file
│   ├── helmfile.yaml               <-- helmfile definition
│   ├── sops.md                     
│   ├── .sops.yaml                  <-- sops file containing all enc/dec rules for sensitive data
│   ├── templates                   <-- This directory cointains all the templates manifest we will need for the service
│   │   ├── configmap.yaml          
│   │   ├── deployment.yaml         
│   │   ├── _helpers.tpl            
│   │   ├── ingress.yaml            
│   │   ├── secrets.yaml            
│   │   └── service.yaml            
│   └── vars                        <-- helm variables directory
│       ├── development             
│       │   ├── secrets.yaml        <-- sensitive values for development env
│       │   └── values.yaml         <-- specific values for development env
│       ├── production              
│       │   ├── secrets.yaml        
│       │   └── values.yaml         
│       └── values.yaml             <-- common values for all the environemnts
├── index.js                        <-- code of the page we are going to show
├── package.json
└── README.md
```

## Files break down

### Dockerfile

A simple service requires just a simple Dockerfile as base for the image creation. It consist on a `node:14` base image and it runs the npm install and expose the service to a given port using environemnt variables.


### ./helm/.sops.yaml

Here I defined the rules to encrypt/decrypt sensitive data. Full explanation here [sops](./helm/sops.md)

### vars

This directory contains the variables I will need to configure the manifests.

#### ./helm/vars/values.yaml

Contains the general values for the services no matter which environment it is being deploy to. the mos relevant values are `readinessProbe` and `livenessProbe` defining where the cluster should check for the herartbeat of the service.

#### ./helm/vars/<env>/values.yaml

This file contains the specific enviromental values for the services. In this file we main find important values like:
- `namespace` to define the namespace in which the service will be deployed
- `image` defining image source, tag and pull secret to use
- `ingress` setting all the values related to the ingress that the service needs to be presented to the outside
- `envs` is really important because here we define all the environemnt variables to be set on the pod using a ConfigMap to inyect them.

#### ./helm/vars/<env>/secrets.yaml

Similar to the envs section of the previous file here we will contain all the sensitive environmental values such as passwords, tokens, etc. But in this case the variables are set under `secrets` section. 

### Templates

This directoy contains the templates for all the manifest we need to make our service to work correctly a brief description of it:

- `configmap.yaml`: using the values file as sources it iterates over them to cerate the configMap that later on will be used by the deployment to inyect those values to the pod.
- `deployment.yaml`: This is the most complex one, here I tried to show as many  deployment manifest capabilities as I could, most remarkable ones are: security context definition, secrets and enviroment variables inyection and affinity rules.
- `ingress.yaml`: here we define how the service will be reached from the exterior.
- `secrets.yaml`: as its non sensitive analog configmap.yaml this files contains all the sensitive data to be inyected into the pod with the data encryted using sops.
- `service.yaml`: definition of the service to use as pods load balancer.
