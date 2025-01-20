{ config, pkgs, ... }:

{
  # Bootloader and filesystem
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/".device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";

  # QEMU guest agent for Proxmox
  services.qemuGuestAgent.enable = true;

  # Hardened SSH
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = "no";
    PubkeyAuthentication = "yes";
    MaxAuthTries = 3;
    AllowAgentForwarding = "no";
    AllowTcpForwarding = "no";
    X11Forwarding = "no";
  };

  # NFS server
  services.nfs.server.enable = true;
  services.nfs.exports = ''
    /mnt/data *(rw,sync,no_subtree_check,fsid=0)
  '';

  # Firewall
  networking.firewall.allowedTCPPorts = [ 22 2221 3000 ];
  networking.firewall.enable = true;

  # Fail2Ban for SSH protection
  services.fail2ban = {
    enable = true;
    filters.sshd = pkgs.fail2banFilters.sshd;
    jails = {
      sshd = {
        port    = "ssh";
        logpath = "/var/log/secure"; # Adjust based on your logging system
        maxretry = 3;
      };
    };
  };


  # Forgejo service
  services.forgejo = {
    enable = true;
    dataDir = "/var/lib/forgejo";
    config = {
      server = {
        DOMAIN = "git.prive.dc.local.hommet.net";
        ROOT_URL = "https://git.prive.dc.local.hommet.net/";
        SSH_PORT = 2221;
      };
      database = {
        DB_TYPE = "sqlite3";
        PATH = "/var/lib/forgejo/data/forgejo.db";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    iftop
  ];

  # Bash completion
  programs.bash.enableCompletion = true;

  # Users
  users.users.jho = {
    isNormalUser = true;
    home = "/home/jho";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"
    ];
  };
}
