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

variable "ssh_password" {
  type = string
  sensitive = true
}

source "proxmox-iso" "alpine-builder" {
  communicator = "ssh"
  boot_command = [
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
    "setup-alpine -f $PWD/answers<enter><wait5>",
    "${var.ssh_password}<enter><wait>",
    "${var.ssh_password}<enter><wait>",
    "<enter><wait10>",
    "apk add -u curl<enter><wait5>",
    /* "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_alpine.sh<enter><wait>", */
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_alpine.sh | sh -<enter><wait20>",
    "reboot<enter>"
  ]
  boot_wait = "10s"
  http_directory = "packer/config"
  http_port_min = 8443
  http_port_max = 8443
  node = "${var.node}"
  vm_id = "1000"
  iso_file = "local:iso/alpine-virt-3.17.2-x86_64.iso"
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
  cores = 2
  cpu_type = "kvm64"
  memory = 2048
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
  ssh_password = "${var.ssh_password}"
  ssh_timeout = "20m"

  template_description = "Alpine 3.17.2, generated o ${timestamp()}"
  template_name = "Alpine-3.17.2"

  unmount_iso = true
}

build {
    sources = ["source.proxmox-iso.alpine-builder"]

    /* provisioner "ansible" { */
    /*   playbook_file = "provisioning/playbooks/tasks/base_image.yml" */
    /*   host_alias = "alpine-linux" */
    /*   use_proxy = false */
    /* } */
}
