# JHMMT Homelab v6

## Goals

- Have a homelab created with IaC, with most of OSS tools ;
- Learn everyday ;
- Be able to deploy my tools and needs anywhere, in any type of machine.

## Informations and limitations

### Misc

Proxmox VE as the base host, OpenTofu for IaC, Ansible (with tox and molecule) to install and configure some tools.

### Limitations

Scripts and files given here are "as it", with no operating obligation. Please respect the LICENSE (GPLv3).

## Proxmox VE

As the 29th of december 2024, my machine is now a Proxmox VE tower. Here's the specifications:

- *MB*: MSI B650M-Pro
- *CPU*: AMD Ryzen 5 4500G (no O.C., no downvoltage)
- *Air cooler*: BeQuiet! Dark Rock PRO 4
- *RAM*: 2 x 8 Gb DDR4 2666 Mhz (Corsair) - no D.O.C.P. profile + 2 x 16 Gb DDR4 3200 Mhz (Corsair) - no D.O.C.P. profile. Total = 48 Gb
- *GPU*: AMD APU of the Ryzen 5
- *System disk*: 1 Tb Crucial P3 m.2 SATA
<!-- - *Data disks*: 2 x 2 Tb Toshiba DT01ACA200 -->
- *Data disk*: 1 Tb Transcend 220S
- *Power supply*: Corsair RM750e
- *Case*: Fractal Design

I used the official ISO of Proxmox VE to install the system on my Crucial SSD in XFS partition. At the first boot (in UEFI). In the Proxmox webUI, I added a local storage (Datacenter > Storage > button "add" > ZFS and I wrote the ZFS pool name `local-zfs`). -->


<!-- ## Proxmox VE - OLD -->

<!-- As the 10th of august 2024, my machine is now a Proxmox VE tower. Here's the specifications:

- *MB*: Asus ROG X470-F Gaming
- *CPU*: AMD Ryzen 7 2700 (no O.C., no downvoltage)
- *Air cooler*: BeQuiet! Dark Rock PRO 4
- *RAM*: 4 x 8 Gb DDR4 2666 Mhz (Kingston) - no D.O.C.P. profile.
- *GPU*: Nvidia GT 720
- *System disk*: 1 Tb Crucial P3 m.2 SATA
- *Data disks*: 2 x 2 Tb Toshiba DT01ACA200
- *Cache disk*: 1 Tb Transcend 220S
- *Power supply*: Corsair RM750e
- *Case*: Thermaltake Level 10

I used the official ISO of Proxmox VE to install the system on my Crucial SSD in EXT4 partition. At the first boot (in UEFI), I had to modify the linux kernel boot line to add "`nomodeset`", to avoid an installation blocking because of Nvidia module.

No tweaks, no hardening (at the moment). I'm using ZFS, a mirrored pool of my two hard drives and the NVME disk as the L2ARC (cache disk). Commands are :

```bash
zpool create local-zfs mirror /dev/sda /dev/sdb
zpool add local-zfs cache /dev/nvme0n1
# ---
zpool status local-zfs
  pool: local-zfs
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	local-zfs   ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sda     ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	cache
	  nvme0n1   ONLINE       0     0     0

errors: No known data errors
```

In the Proxmox webUI, I added this ZFS storage (Datacenter > Storage > button "add" > ZFS and I wrote the ZFS pool name `local-zfs`). -->

## SOPS and age

These tools are used to hide some sensible values. My homelab is a no critical infrastructure nor have sensible datas, but it's a good way to hide some values.

```bash
# I'm using MacOS
brew update && brew install age opentofu sops

# generate the age key pair, used for encryption and decryption
age-keygen -o key.txt
# create a .sops folder to store your key.txt age file, and copy it into this folder.
mkdir -p $HOME/.sops
cp key.txt $HOME/.sops/.
echo "export SOPS_AGE_KEY_FILE=~/.sops/key.txt" >> $HOME/.zprofile
```

The file `.sops.yaml` is used to configure sops with your age pubkey, some rules for encryption or descryption (files, methods...).

I stored my PVE secrets in the file `pve_secrets.yaml`, an example is given in the file `pve_secrets.yaml.example`. Encrypt the file with the command `sops -e -i pve_secrets.yaml`. To decrypt you have to type `sops -d -i pve_secrets.yaml`.

## OpenTofu

```bash
# I'm using MacOS
brew update && brew install opentofu

ssh root@<pve_host>
pveum user add opentofu@pve
pveum role add OpenTofu -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify SDN.Audit Pool.Audit Mapping.Use Mappping.Audit Mapping.Modify Realm.AllocateUser Permissions.Modify"
pveum aclmod / -user opentofu@pve -role OpenTofu
pveum user token add opentofu@pve provider --privsep=0
```

To start some commands, do :

```bash
cd homelab && tofu fmt -recursive -diff
# tofu plan -parallelism=5 -concise -out otplan
# tofu plan -concise -target='proxmox_virtual_environment_vm.vm["ups01"]' -out otplan
# tofu apply -parallelism=5 otplan

## VM
# tofu plan -var-file=<nomDeLaVM>.tfvars -concise -out nomDeLaVMplan
tofu plan -var-file=dodge.tfvars -concise -out dodgeplan -state=dodge.tfstate
tofu plan -var-file=ram.tfvars -concise -out ramplan -state=ram.tfstate
tofu plan -var-file=viper.tfvars -concise -out viperplan -state=viper.tfstate
# tofu apply <nomDeLaVM>plan
tofu apply -state=dodge.tfstate dodgeplan
tofu apply -state=ram.tfstate ramplan
tofu apply -state=viper.tfstate viperplan
# tofu destroy -var-file=<nomDeLaVM>.tfvars
tofu destroy -var-file=dodge.tfvars
tofu destroy -var-file=ram.tfvars
tofu destroy -var-file=viper.tfvars
```
