# Vagrant Windows 11 .NET 6+ Development Environment

## Ready Made Windows 11 Modern .NET Development Environment

This repository contains a Powershell script automatically creates a ready-to-go Window 11 Development Environment in a two-stage process:

1. Use Packer to create a Vagrant base box from from stock .iso images
2. Use Vagrant to create a working Virtualbox or Hyper-V virtual machine from the base box

## Basic Requirements

### Tools To Install:

* A virtual machine hypervisor. Either: 

    * [VirtualBox](https://www.virtualbox.org/) (_Preferred, cross-platform. Use if Hyper-V is not already installed._)

        ```
        choco install virtualbox
        ```

    * *OR*

    * [Hyper-V](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) (_Windows only, use only if already installed._)
        
        * Virtuabox is strongly preferred. _Once you have installed Hyper-V, no other hypervisor will work on your computer short of a full partition wipe. This a long-known drawback of Hyper-V_ Hyper-V support is only for those machines that already have it installed and are now stuck with it.
        
        * Either grant your user machine-level admin permissions (not recommended) or add you user account to the `Hyper-V Administrators` group via `lusrmgr.msc` (preferred).
    

* [Packer](https://packer.io/)
    
    ```
    choco install packer
    ```

* [Vagrant](https://vagrantup.com/)
    
    * Read the documentation on the basic Vagrant commands. At least know [vagrant up](https://www.vagrantup.com/docs/cli/up), [ vagrant halt](https://www.vagrantup.com/docs/cli/halt), and [ vagrant destroy](https://www.vagrantup.com/docs/cli/destroy).

    ```
    choco install vagrant
    ```

* Windows ADK
    
    ```
    choco install windows-adk-oscdimg
    ```

### Other Requirements

* At least 120GB free space 
* Windows 11 `.iso` file
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

Once you're up and running, the base box is no longer needed. Vagrant keeps imported boxes under `~\vagrant.d\`. Delete the `.box` file created in this repo folder and give your hard drive some space back. Same goes for the `.iso` files if you have access to them somewhere else.

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
