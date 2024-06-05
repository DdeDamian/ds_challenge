# SOPS

This page is intended to describe the encryption mechanism that we are using, mainly to encrypt sensitive data on Bitbucket repos.

## Table of Contents

- [SOPS](#sops)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [How it works?](#how-it-works)
    - [Breaking the file down](#breaking-the-file-down)
  - [How I'm implementing it?](#how-im-implementing-it)
  - [Usage](#usage)
    - [Common step](#common-step)
    - [Encripted file creation](#encripted-file-creation)
    - [Editing encrypted file](#editing-encrypted-file)
    - [Get values from encrypted file](#get-values-from-encrypted-file)
  - [Common Errors](#common-errors)

## Installation
For tha installation we just need to run two commands

```bash
curl -Lo sops_3.7.3_amd64.deb https://github.com/mozilla/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
sudo dpkg sops_3.7.3_amd64.deb
```
More info [here](https://github.com/mozilla/sops). Alternative versions [here](https://github.com/mozilla/sops/releases).


## How it works?
**sops** is an editor of encrypted files that supports YAML, JSON, ENV, INI and BINARY formats and encrypts with AWS KMS, GCP KMS, Azure Key Vault, age, and PGP.

To define how sops will behaves in the encrypt/decrypt process you will need to define a `.sops.yaml` file in which you set the parameters needed. In general it has a format smilar to this:

```yaml
# creation rules are evaluated sequentially, the first match wins
creation_rules:
        # upon creation of a file that matches the pattern *.dev.yaml,
        # KMS set A is used
        - path_regex: \.dev\.yaml$
          kms: 'arn:aws:kms:us-west-2:927034868273:key/fe86dd69-4132-404c-ab86-4269956b4500,arn:aws:kms:us-west-2:361527076523:key/5052f06a-5d3f-489e-b86c-57201e06f31e+arn:aws:iam::361527076523:role/hiera-sops-prod'
          pgp: 'FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4'

        # prod files use KMS set B in the PROD IAM
        - path_regex: \.prod\.yaml$
          kms: 'arn:aws:kms:us-west-2:361527076523:key/5052f06a-5d3f-489e-b86c-57201e06f31e+arn:aws:iam::361527076523:role/hiera-sops-prod,arn:aws:kms:eu-central-1:361527076523:key/cb1fab90-8d17-42a1-a9d8-334968904f94+arn:aws:iam::361527076523:role/hiera-sops-prod'
          pgp: 'FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4'
          hc_vault_uris: "http://localhost:8200/v1/sops/keys/thirdkey"

        # gcp files using GCP KMSm
        - path_regex: \.gcp\.yaml$
          gcp_kms: projects/mygcproject/locations/global/keyRings/mykeyring/cryptoKeys/thekey

        # Finally, if the rules above have not matched, this one is a 
        # catchall that will encrypt the file using KMS set C
        # The absence of a path_regex means it will match everything
        - kms: 'arn:aws:kms:us-west-2:927034868273:key/fe86dd69-4132-404c-ab86-4269956b4500,arn:aws:kms:us-west-2:142069644989:key/846cfb17-373d-49b9-8baf-f36b04512e47,arn:aws:kms:us-west-2:361527076523:key/5052f06a-5d3f-489e-b86c-57201e06f31e'
          pgp: 'FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4'
```

### Breaking the file down

`creation_rules`: this is the main item of the yaml, under this all the rules are created,

`path_regex`: this is important to define which rule will be applied to which file. The path_regex checks the path of the encrypting file relative to the .sops.yaml config file.

lastly we have the definition for every platform key that sops supports. `kms`, `pgp`, `gcp_kms`, `azure-kv`, `hc_vault`, `age`

More information [here](https://github.com/mozilla/sops/blob/master/README.rst).

## How I'm implementing it?
Right now I'm using sops in combination with KMS keys. I'm creating the `.sops.yaml` file in the root of helm directory that uses it.

Here we have the files structure:
```
.
├── config.json
├── Dockerfile
├── helm
│   ├── Chart.yaml
│   ├── helmfile.yaml
│   ├── sops.md
│   ├── .sops.yaml
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── ingress.yaml
│   │   ├── secrets.yaml
│   │   └── service.yaml
│   └── vars
│       ├── development
│       │   ├── secrets.yaml
│       │   └── values.yaml
│       ├── production
│       │   ├── secrets.yaml
│       │   └── values.yaml
│       └── values.yaml
├── index.js
├── package.json
└── README.md
```

In the root of the project we have a file called `.sops.yaml` and the content is:
```yaml
---
creation_rules:
  # KMS service for development
  - path_regex: vars/development/(certs.)?secrets(.dec)?.yaml
    kms: "arn:aws:kms:eu-central-1:891377286140:key/f1923757-a017-4257-9541-a064da4703b1+arn:aws:iam::891377286140:role/KMSHandling"
  # # KMS service for production
  # - path_regex: vars/production/(certs.)?secrets(.dec)?.yaml
  #   kms: "arn:aws:kms:eu-central-1:891377286140:key/f1923757-a017-4257-9541-a064da4703b1+arn:aws:iam::891377286140:role/KMSHandling"

```

We’ve defined a different rule for each environment so all the files that match the path_regex `vars/development/(certs.)?secrets(.dec)?.yaml` will be decripted with development key and the same for the rest of the environments.

The kms key is composed by two parts one defining the key itself and the other part the role that has permissions to access it, both separeted by a + sign

ARN of the key: arn:aws:kms:eu-central-1:891377286140:key/f1923757-a017-4257-9541-a064da4703b1

ARN of the profile: arn:aws:iam::891377286140:role/KMSHandling

## Usage
To access the KMS keys to use sops you need to make sure that your user has enough privileges to use the KMS key through the KMSHandling role.

### Common step
In all the steps defined bellow first you need to export your AWS credentials for the Identity account

```bash
export AWS_PROFILE=<aws-profile>
# i.e export AWS_PROFILE=DS-CHALLENGE
```

### Encripted file creation
If you are creating a file from scratch we recommend to start it with just a file containing this `{}` and then apply the encryption

```bash
export AWS_PROFILE=<aws-profile>
echo "{}" > ./vars/development/secrets.dec.yaml
sops -e ./vars/development/secrets.dec.yaml > ./vars/development/secrets.yaml
```

Resulting in something like this

```yaml
sops:
    kms:
        - arn: arn:aws:kms:eu-central-1:891377286140:key/f1923757-a017-4257-9541-a064da4703b1
          role: arn:aws:iam::891377286140:role/KMSHandling
          created_at: "2024-06-05T21:16:55Z"
          enc: AQICAHgjT9l3LyUI75g9rAXy/uWWtXesqbQMGOS7C/2JD8HhRQHk1XipQ6yKBCrrOgN2SWSQAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMk2NUy0JWCut5MkB2AgEQgDscEazgIBD/OA+0sxyo3uzqotev5aDQKp778E+hiN8ffneSoSQ2wOGif0VXTpkjtFYCMWuCJBT/1xPSXA==
          aws_profile: ""
    gcp_kms: []
    azure_kv: []
    hc_vault: []
    age: []
    lastmodified: "2024-06-05T21:16:56Z"
    mac: ENC[AES256_GCM,data:tYgG7PW3loO+jlUhxMQYYnM+PAbmBAk7jJOCQBQK+tgQD41ZUyiwxuDAQPsJdU949JK0YMuNLgs4OUI+cSiapUA1TFeGhEZ9VFbBXUmlralqJA6zaPrHb+/+5mQe1MWrN6k4SnEBAUkVgqHXkXhFx0LBuC2Zp0KNrWWLt+L1TUA=,iv:A8VxSX5GGeAAwGUP555VAYqolfbAboWu8/cLvQnMscs=,tag:F1PeuLuoaXbtd1JLgNzkGw==,type:str]
    pgp: []
    unencrypted_suffix: _unencrypted
    version: 3.8.1
```

### Editing encrypted file

```bash
export AWS_PROFILE=<aws-profile>
sops vars/playground.enc.yaml
```

This will open your default console editor, the data will be unencrypted and you will be able to add, remove or modify values. Once you save the file it will be encrypted automatically.

### Get values from encrypted file
```bash
export AWS_PROFILE=<aws-profile>
sops -d vars/playground.enc.yaml
```
This will show the decrypted vales in the terminal.

## Common Errors

**error loading config: no matching creation rules found**

In general this error is cause if you are placed in the incorrect directory

**Failed to get the data key required to decrypt the SOPS file.**

This happens when your credentials were not loaded or are incorrect

and it will show you something like this

```
Group 0: FAILED
  arn:aws:kms:eu-central-1:891377286140:key/f1923757-a017-4257-9541-a064da4703b1: FAILED
    - | Error creating AWS session: Failed to assume role
      | "arn:aws:iam::891377286140:role/KMSHandling":
      | NoCredentialProviders: no valid providers in chain.
      | Deprecated.
      | 	For verbose messaging see
      | aws.Config.CredentialsChainVerboseErrors
```
 