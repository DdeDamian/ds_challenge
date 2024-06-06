# Tools installation

This section is intended to help mainly linux users to install the different tools we will need for this project. You can also follow the official docs that it is mention on each section.

## Table of Contents
- [Tools installation](#tools-installation)
  - [Table of Contents](#table-of-contents)
  - [Basic tools](#basic-tools)
  - [aws-cli](#aws-cli)
  - [sops](#sops)
  - [kubectl](#kubectl)
  - [helmswitch](#helmswitch)
    - [helm-secrets](#helm-secrets)
    - [helm-diff](#helm-diff)
  - [Terraform-switch](#terraform-switch)
  
## Basic tools

you will need som base tools for everything to work, so just run:

```bash
sudo apt update
sudo apt install git curl apt-transport-https unzip python3-pip
```

## aws-cli
The AWS Command Line Interface (AWS CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

```bash
# Download installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip it
unzip awscliv2.zip

# Run the install
sudo ./aws/install
```

To easily configure your environment we suggest to use this two templates, both of them should be under ~/.aws/ :
```
# credentials
# ~/.aws/credentials

[DS-CHALLENGE]
aws_access_key_id = <your-key-id>
aws_secret_access_key = <your-secret-key>
```

## sops

```bash
# Download the binary
curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64

# Move the binary in to your PATH
mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops

# Make the binary executable
chmod +x /usr/local/bin/sops
```

## kubectl

The Kubernetes command-line tool, `kubectl`, allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs. For more information including a complete list of kubectl operations, see the kubectl reference documentation.


```bash
# Download the latest release
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download the kubectl checksum file
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Validate (you should see "kubectl: OK")
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# install
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# test
kubectl version --client
```

## helmswitch

helmswitch is a CLI tool to install and switch between different versions of Helm. Once installed, just run the command and use the dropdown to choose the desired version of Helm. More info here.

```bash
# Download the latest release
wget https://github.com/tokiwong/helm-switcher/releases/download/v0.0.6/helmswitch-linux-amd64.zip #Look for latest version

# Unzip it
unzip helmswitch-linux-amd64.zip

# Make the binary executable
chmod +x helmswitch

# Install
mv helmswitch /usr/local/bin/

# Install helm
helmswitch # select the version you want
```

  ### helm-secrets

  ```bash
  helm plugin install https://github.com/jkroepke/helm-secrets
  ```

  ### helm-diff
  ```bash
  helm plugin install https://github.com/databus23/helm-diff
  ```

## Terraform-switch
The `tfswitch` command line tool lets you switch between different versions of terraform. If you do not have a particular version of terraform installed, tfswitch will download the version you desire. The installation is minimal and easy. Once installed, simply select the version you require from the dropdown and start using terraform.


```bash
# Install tfswitch
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Install terraform
tfswitch # select the version needed
```