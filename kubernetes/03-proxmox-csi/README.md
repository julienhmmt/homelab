# Utiliser le stockage Proxmox comme stockage persistent pour Kubernetes

## Préparation et installation

Follow <https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/install.md>

```bash
pveum role add CSI -privs "VM.Audit VM.Config.Disk Datastore.Allocate Datastore.AllocateSpace Datastore.Audit"
pveum user add kubernetes-csi@pve
pveum aclmod / -user kubernetes-csi@pve -role CSI
pveum user token add kubernetes-csi@pve csi -privsep 0
```

*All VMs in the cluster must have the SCSI Controller set to VirtIO SCSI single or VirtIO SCSI type to be able to attach disks.*

Helm & kubectl

Modifier les valeurs du fichier `03-proxmox-csi-custom-values.yaml`.

```bash
helm template --namespace csi-proxmox --create-namespace -f 03-proxmox-csi-custom-values.yaml proxmox-csi-plugin oci://ghcr.io/sergelogvinov/charts/proxmox-csi-plugin > 03-proxmox-csi-install.yaml
kubectl apply -f 03-proxmox-csi-install.yaml
```

## Sources

- https://github.com/sergelogvinov/proxmox-csi-plugin
- https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/deploy/proxmox-csi-plugin-talos.yml
