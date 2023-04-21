packer {
  required_plugins {
    proxmox = {
      version = ">=1.1.2"
      source = "github.com/hashicorp/proxmox"
    }
  }
}

variable "answers_url" {
  type = string
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
    "wget -O answers ${ var.answers_url }<enter><wait4>",
    "setup-alpine -f $PWD/answers<enter><wait10>",
    "${var.ssh_password}<enter><wait>",
    "${var.ssh_password}<enter><wait>",
    "<enter><wait5>",
    "apk add -u sed qemu-guest-agent python3<enter><wait10>",
    "rc-update add qemu-guest-agent<enter><wait>",
    "sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config<enter><wait>",
    "export ROOTFS=btrfs<enter>",
    "echo 'y' | setup-disk -m sys -s 0 /dev/sda<enter><wait40>",
    "reboot<enter>"
  ]
  boot_wait = "10s"
  node = "${var.node}"
  iso_file = "local:iso/alpine-virt-3.17.3-x86_64.iso"
  cloud_init = "true"
  cloud_init_storage_pool = "local"
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
  cpu_type = "host"
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

  template_description = "Alpine 3.17.3, generated o ${timestamp()}"
  template_name = "Alpine-3.17.3"

  unmount_iso = true
}

build {
    sources = ["source.proxmox-iso.alpine-builder"]

    provisioner "ansible" {
      playbook_file = "provisioning/playbooks/tasks/base_image.yml"
      host_alias = "alpine-linux"
      use_proxy = false
      extra_arguments = ["-e ansible_ssh_pass=packer"]
    }
}
