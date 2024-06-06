# Step-by-step

- Steps

  - AWS account
    - Create KMSHandling policy
    - Create KMS key for sops

  - Github
    - creaate repo
    - generate token
    - add pipeline 

  - Terraform
    - Create modules
      - VPC
      - Subnets
      - Security Groups
      - EKS
      - policy
      - role
  
    - Implement modules
      - VPC
      - Subnets
      - Security Groups
      - EKS
      - etc

  - Kubernetes
    - Create container(s) with docker
    - Create K8s manifests
      - use helm, helmfile to deploy

  - Manage accesibility
    - Buy domain
    - Create certificate
    - Deploy ingress-controller
      - Automatically creates LB
  - 
  - Deploy service
    - create code
    - create docker file and build image
    - deploy service using helm (helmfile, sops, etc)
    - create github action to handle previous steps automaatically
