variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "204800"
}

variable "windows_iso_checksum" {
  type    = string
  default = ""
}

variable "windows_iso_url" {
  type    = string
  default = "../iso/windows_11.iso"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "vm_name" {
  type    = string
  default = "windows_11_hyperv"
}

variable "hyperv_configuration_version" {
  type    = string
  default = "9.2"
}

variable "enable_dynamic_memory" {
  type = bool
  default = true
}

source "hyperv-iso" "windows11" {
  boot_command                     = ["a<wait>a<wait>a"]
  boot_wait                        = "-1s"
  cd_files                         = [
                                        "../answer_files/Autounattend.xml", 
                                        "../scripts/packer/setup/Setup.ps1",
                                     ]
  communicator                     = "ssh"
  configuration_version            = var.hyperv_configuration_version
  cpus                             = var.cpus
  disk_size                        = var.disk_size
  enable_dynamic_memory            = var.enable_dynamic_memory
  enable_mac_spoofing              = true
  enable_secure_boot               = true
  enable_virtualization_extensions = false
  generation                       = "2"
  iso_checksum                     = var.windows_iso_checksum
  iso_url                          = var.windows_iso_url
  memory                           = var.memory
  shutdown_command                 = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  switch_name                      = "Default Switch"
  vm_name                          = var.vm_name
  ssh_timeout                      = "1h"
  ssh_username                     = "vagrant"
  ssh_password                     = "vagrant"
}


build {
  sources = [
    "source.hyperv-iso.windows11"
  ]

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    elevated_user     = "vagrant"
    elevated_password = "vagrant"
    scripts           = ["../scripts/packer/provisioning/Enable-WindowsFeatures.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    elevated_user     = "vagrant"
    elevated_password = "vagrant"
    scripts           = ["../scripts/packer/provisioning/Install-ChocoPackages.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    elevated_user     = "vagrant"
    elevated_password = "vagrant"
    inline            = ["Optimize-Volume -DriveLetter C -Defrag -ReTrim"]
  }

  post-processor "vagrant" {
    output               = "windows11-hyperv.box"
    vagrantfile_template = "vagrantfile-windows11-hyperv.template"
  }
}
