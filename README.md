# JHMMT Homelab

## Goals

- Have a homelab created with IaC, with most of OSS tools ;
- Learn everyday ;
- Be able to deploy my tools and needs anywhere, in any type of machine.

## Informations and limitations

### Misc

Proxmox VE as the base host, OpenTofu for IaC, Talos for kubernetes, argocd for CD.

### Limitations

Scripts and files given here are "as it", with no operating obligation. Please respect the LICENSE.

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
