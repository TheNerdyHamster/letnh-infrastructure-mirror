packer {
  required_plugins {
    proxmox = {
      version = ">=1.1.2"
      source = "github.com/hashicorp/proxmox"
    }
  }
}

variable "token" {
  type = string
  sensitive = true
}

variable "username" {
  type = string
}

variable "url" {
  type = string
}

variable "node" {
  type = string
  default = "vhost1"
}

source "proxmox-iso" "rocky-kickstart" {
  #boot_command = ["<up><enter>"]
  communicator = "ssh"
  boot_command = ["<up><tab> ip=dhcp inst.cmdline inst.ks=https://git.sr.ht/~thenerdyhamster/infrastructure/blob/main/packer/config/rocky-ks.cfg<enter>"]
  boot_wait = "10s"
  http_directory = "packer/config"
  http_port_min = 8443
  http_port_max = 8443
  node = "${var.node}"
  iso_file = "local:iso/Rocky-9.1-x86_64-minimal.iso"
  os = "l26"
  bios = "seabios"
  scsi_controller = "virtio-scsi-single"
  disks {
    disk_size = "12G"
    storage_pool = "local"
    type = "scsi"
    format = "qcow2"
  }
  sockets = 1
  cores = 4
  cpu_type = "host"
  memory = 4096
  network_adapters {
    bridge = "vmbr1"
    model = "virtio"
    firewall = false
  }
  insecure_skip_tls_verify = true
  task_timeout = "1m"

  proxmox_url = "${var.url}"
  username = "${var.username}"
  token = "${var.token}"

  ssh_username = "root"
  ssh_password = "packer"
  ssh_timeout = "6m"

  template_description = "Rocky 9.1, generated o ${timestamp()}"
  template_name = "rocky-9.1"

  unmount_iso = true
}

build {
  sources = ["source.proxmox-iso.rocky-kickstart"]

  provisioner "ansible" {
    playbook_file = "provisioning/playbooks/tasks/base_image.yml"
    host_alias = "rocky-9.1-base"
    use_proxy = false
    extra_arguments = ["-e ansible_ssh_pass=packer"]
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa'",
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }
}
