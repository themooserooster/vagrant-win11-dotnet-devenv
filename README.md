# Vagrant Windows 11 .NET 6+ Development Environment

## Ready Made Windows 11 Modern .NET Development Environment

This repository contains a Powershell script automatically creates a ready-to-go Window 11 Development Environment in a two-stage process:

1. Use Packer to create a Vagrant base box from from stock .iso images
2. Use Vagrant to create a working Hyper-V virtual machine from the base box

## Basic Requirements

### Tools To Install:

* [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
    * Either grant your user machine-level admin permissions (not recommended) or add you user account to the `Hyper-V Administrators` group via `lusrmgr.msc` (preferred). 
* [Packer](packer.io)
    * Packer comes as a .zip archive. Put `packer.exe` in a common location like `C:\tools` and add that location to the system PATH (*not the user PATH*).
* [Vagrant](vagrantup.com)
    * Read the documentation on the basic Vagrant commands. At least know [vagrant up](https://www.vagrantup.com/docs/cli/up), [ vagrant halt](https://www.vagrantup.com/docs/cli/halt), and [ vagrant destroy](https://www.vagrantup.com/docs/cli/destroy).
* [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install#other-adk-downloads) (You only need to check the `DISM` subfeature in the installer. It installs `oscdimg.exe`, a utility Packer relies on)
    * Add the `oscdimg.exe` location to the system PATH. It's normally in a location like `C:\Program Files (x86)\Windows Kits<YOUR WINDOWS VERSION HERE>\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\`. From the edit PATH dialog, you can browse for it. 

### Other Requirements

* At least 120GB free space 
* Windows 11 `.iso` file
* SQL Server 2019 `.iso` file
* A Windows 11 Product Key
* A Visual Studio 2022 Product Key

Contact the Web Team developer or a system administrator if you need help with any of these.

## Make The Thing Run

1. Place the required `.iso` files in the `/iso` directory of this repo. See further instructions for installation images [here](iso/README.md)
1. Make a copy of `variables.auto.pkrvars.hcl.example`. Rename the **copy** `variables.auto.pkrvars.hcl`. Set the variable values in the file accordingly (.iso names, image checksums, etc). _Make sure you have enough free space, RAM, and CPUs to run the virtual machine._
1. Make a copy of `devEnvSettings.json.example`. Rename the **copy** `devEnvSettings.json`. Enter the appropriate settings in the file.
1. In PowerShell, navigate to the root of this repo and execute `.\Initialize-DevelopmentEnvironment.ps1`

*Don't let the computer go to sleep while the VM is being built. This can cause the process to fail and then you have to start all over. If you have to leave the computer, put a long-running video (on mute, you animal!) on full screen to prevent your computer from going to sleep.*

## Now That That's Done

### DO Use The Vagrant CLI, DON'T Use Hyper-V Manager
From here on, you should only access and manage this VM via `vagrant` on the command line and its commands; especially `up`, `halt`, and `destroy`. **DO NOT** ever use the Hyper-V Manager to delete the VM. There is an important script that must run to deactivate the Windows product key before the VM can be deleted. Hyper-V Manager cannot do this itself. You must use `vagrant destroy` if you want to delete this VM.

Honestly, you're going to be using Vagrant weekly if not daily from here on out, so you might as well learn all the available commands.

## Good-To-Know

Once you're up and running, the base box is no longer needed. Vagrant keeps imported boxes under `~\vagrant.d\`. Delete the `.box` file created in this repo folder and give your hard drive some space back. Same goes for the `.iso` files if you have acess to them somewhere else.

#### The script will adjust the following settings for Vagrant compatibility:

* OpenSSH service configured and started automatically.
* Vagrant default insecure ssh key for Vagrant SSH provisioning compatibility.
* 32 & 64 bit Powershell execution policy set to RemoteSigned.  
* UAC disabled.  
* RDP enabled.  
* Networks set to private.  
* Hibernation disabled.  
* Screensaver disabled.  
* Automatic logon enabled.  
* Default admin user: vagrant  
* Default admin password: vagrant
* Enable and install all available Windows and Microsoft updates.
