param(
    [switch]$Debug = $false
)

$ErrorActionPreference = 'Stop'

function Invoke-Packer {
    if ($Debug) {
        $env:PACKER_LOG=1
        $env:PACKER_LOG_PATH=".\packerlog.txt"
    }
    
    try {
        packer build . 
    }
    catch {
        Write-Error "Packer experienced an error. Cancelling development environment build..."
        Write-Error $_
    }
}

function Initialize-Vagrant {
    vagrant box add --name windows_11_hyperv .\windows_11_hyperv.box
    vagrant init windows_11_hyperv
}

function Invoke-VagrantUp {
    vagrant up
}

function Clear-PreviousBuild {
    if (Test-Path -Path .\output-windows11) {
        Remove-Item -Path .\output-windows11 -Recurse -Force
    }
    
    if (Test-Path -Path Vagrantfile) {
        Remove-Item -Path Vagrantfile
    }

    if (Test-Path -Path .vagrant) {
        Remove-Item -Path .vagrant -Recurse -Force
    }
}


Clear-PreviousBuild

if (!(Test-Path -Path .\windows_11_hyperv.box)) {
    Invoke-Packer
}

Initialize-Vagrant;
Invoke-VagrantUp;
