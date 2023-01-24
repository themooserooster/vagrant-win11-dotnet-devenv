variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "65536"
}

variable "windows_iso_checksum" {
  type    = string
  default = ""
}

variable "windows_iso_url" {
  type    = string
  default = "./iso/windows11.iso"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "vm_name" {
  type    = string
  default = "windows11-virtualbox"
}

source "virtualbox-iso" "windows11" {
  iso_checksum                     = var.windows_iso_checksum
  iso_url                          = var.windows_iso_url
  guest_os_type                    = "Windows10_64"
  vm_name                          = var.vm_name
  boot_command                     = ["a<wait>a<wait>a"]
  # shutdown_command                 = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  boot_wait                        = "-1s"
  cd_files                         = [
                                        "./answer_files/Autounattend.xml", 
                                        "./scripts/packer/setup/Setup.ps1",
                                     ]
  communicator                     = "ssh"
  ssh_timeout                      = "1h"
  ssh_username                     = "vagrant"
  ssh_password                     = "vagrant"
  cpus                             = var.cpus
  memory                           = var.memory
  disk_size                        = var.disk_size
  hard_drive_nonrotational         = true
  hard_drive_discard               = true
  gfx_controller                   = "vboxsvga"
  gfx_vram_size                    = 128
  gfx_accelerate_3d                = true
  firmware                         = "efi"
  nested_virt                      = true
  gfx_efi_resolution               = "1920x1080"
  acpi_shutdown                    = true
}

build {
  sources = [
    "source.virtualbox-iso.windows11"
  ]

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    elevated_user     = "vagrant"
    elevated_password = "vagrant"
    scripts           = ["./scripts/packer/provisioning/Enable-WindowsFeatures.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    elevated_user     = "vagrant"
    elevated_password = "vagrant"
    scripts           = ["./scripts/packer/provisioning/Install-ChocoPackages.ps1"]
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
    output               = "windows11-virtualbox.box"
    vagrantfile_template = "./virtualbox/vagrantfile.template"
  }
}
