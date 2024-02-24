# JHMMT Homelab

Hey, welcome on board! This README is still (and will be) in draft... Look what are we talking about:

## Project and goals

This repository is intended to be used into my homelab. It is an automatisation of things as most as possible and create a Kubernetes cluster. Goals are multiple:

- learn and use terraform/opentofu into my Proxmox hosts
- learn and use ansible to configure roles and settings in VM and CT
- learn and use kubernetes to deploy many containerized apps

## Architecture

- 3 hosts (each have 1x N100, 1x Gbit/s, 12 Gb LPDDR5, 1x512 Gb NVMe)
  - Debian 12 with Proxmox 8.1 on top
- 1 switch to commute them
- 1 mikrotik rb4011 to route some networks

[architecture_pic]

## How to use

Tox is used to have needed dependencies. Install `tox` and start it:

```bash
tox
source .tox/py3-ansible/bin/activate
```

### Packer

Used to generate an Ubuntu Jammy template with cloud-init. Inspiration from "https://github.com/marcinbojko/proxmox-kvm-packer/".

In the folder "_packer_", do:

```bash
packer init ubuntults.pkr.hcl
packer fmt -diff -recursive ubuntults.pkr.hcl
packer fmt -diff -recursive custom.pkrvars.hcl
packer validate -var-file=custom.pkrvars.hcl ubuntults.pkr.hcl
packer build -var-file=custom.pkrvars.hcl ubuntults.pkr.hcl
```

I wrote a document to give you information about the workflow :

- french version : <https://j.hommet.net/packer-et-proxmox/>
- english version : <https://j.hommet.net/use-packer-on-proxmox-vm-templates/>

### Terraform

Used to provision the infra.

Folder "_terraform_" have multiple folders to organize the needs. Each folders have its provider, its variables and resources. At the moment, I do not plan to use modules.

In each folder, do:

```bash
terraform init -upgrade
terraform fmt -recursive -diff
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

Commands are the same between Terraform v1.6.x and OpenTofu v1.6.x.

I wrote a document on my website to give you more information about this part :

- french version "terraform et conteneurs LXC pour Proxmox" : <https://j.hommet.net/terraform-ct-pour-proxmox/>
- french version "terraform et VM pour Proxmox" : <https://j.hommet.net/terraform-opentofu-creer-vm-proxmox/>
- english version "terraform and LXC containers for Proxmox : <https://j.hommet.net/use-terraform-to-create-pve-lxc/>
- english version "terraform and VM for Proxmox" : TODO

### Ansible

Used to configure services.

Folder "_ansible_" is a playbook repository, where I'm using my ansible roles. Tags are "nodeexporter", "pveexporter".

In the folder, do:

```bash
ansible-galaxy install -r requirements.yml --force-with-deps
ansible-playbook play.yml --check --diff --ssh-common-args='-o StrictHostKeyChecking=no' --tags __change__ --limit=__change__
# For LXC, you maybe need to force the ansible_user to root, like this:
ansible-playbook play.yml --check --diff --ssh-common-args='-o StrictHostKeyChecking=no' --tags __change__ --limit=__change__ -e ansible_user=root
```

## Usage

Fell free to re-use this repository and fits it to your needs. There's many things to do...
