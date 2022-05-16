locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


variable "preseed_file" {
  type    = string
  default = "preseed/default.cfg"
}

/* *********************************************************
 * vSphere virtual machine configuration
 * *********************************************************
 */
variable "name" {
  type    = string
  default = "debian-11.3.0"
}

variable "notes" {
  type    = string
  default = "Created/ Managed by Packer"
}

variable "memory" {
  type    = number
  default = 1024
}

variable "cpu" {
  type    = number
  default = 2
}


/* *********************************************************
 * Network and datastore configuration
 */
variable "domain" {
  type    = string
  default = "infra.risewi.de"
}

// portgroup on the DVS configured in vsphere.pkr.hcl
variable "portgroup" {
  type    = string
  default = "vlan_010"
}

// Packer waits for an IP of this range to come up after the 
// base install is done
variable "network" {
  type    = string
  default = "192.168.10.0/24"
}

// datastore to store the vm on
variable "datastore" {
  type    = string
  default = "AFF"
}



/* *********************************************************
 * vSphere ISO parameters 
 * *********************************************************
 */
source "vsphere-iso" "debian" {
  // Configuration 
  CPUs                 = var.cpu
  RAM                  = var.memory

  // VM meta information
  vm_name        = var.name
  notes          = var.notes
  
  // Linux guest customization does not work with debian11_64Guest, ref: https://kb.vmware.com/s/article/85845
  // guest_os_type        = "debian11_64Guest"
  // guest_os_type        = "otherGuest64" funktioniert nicht
  guest_os_type        = "otherLinux64Guest"


  // Directory that is served via Packer's webserver
  http_directory       = path.root
  
  // Getting the ISO boot up and running
  boot_command = [
    "<wait><wait><wait><esc><wait><wait><wait>",
    "/install.amd/vmlinuz ",
    "initrd=/install.amd/initrd.gz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
    "hostname=${var.name} ",
    "domain=${var.domain} ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>"
  ]

  // recommended setting by vsphere
  disk_controller_type = ["pvscsi"]
  
  insecure_connection  = var.vsphere_allow_insecure_connection
  iso_paths            = ["[AFF] _iso/debian-11.3.0-amd64-netinst.iso"]
  network_adapters {
    network_card = "vmxnet3"
    network = var.portgroup
  }

  ssh_username= var.ssh_username
  ssh_password = var.ssh_password

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  ip_wait_address = var.network

  username       = var.vsphere_deployment_username
  password       = var.vsphere_deployment_password
  vcenter_server = var.vsphere_vcenter

  cluster        = var.vsphere_cluster
  host           = var.vsphere_target_esx_host
  datastore      = var.datastore
}


/* *********************************************************
 * Build 
 * *********************************************************
 */
build {
  name = var.name

  sources = ["source.vsphere-iso.debian"]

  # Deploying the .ssh key for the deployment user to /tmp
  # It will be added to the authorized_keys file in
  # the next provisioner (scripts/01_provision_deploy_user.sh) 
  provisioner "file" {
    source      = "ssh-keys/deploy.pub"
    destination = "/tmp/deploy.pub"
  }

  # Provide the deployment user for subsequent configurations with remote ansible configurations
  provisioner "shell" {
    script = "scripts/01_provision_deploy_user.sh"
  }

  # Install ansible for basic setup
  provisioner "shell" {
    script = "scripts/02_install_ansible.sh"
  }

  # Configure the server with the default ansible setup playbook
  provisioner "ansible-local" {
    playbook_file = "scripts/03_ansible-setup.yml"
  }

  # Cleaning up
  provisioner "shell" {
    script = "scripts/04_cleanup.sh"
  }
}


/* *********************************************************
 * Packer configuration
 * *********************************************************
 */
packer {
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/vsphere"
    }
  }
}