param(
    [switch]$Debug = $false,
    [string][ValidateSet("HyperV", "Virtualbox")][Parameter(Mandatory = $true)]$Format
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

    if (Test-Path -Path .\windows_11_hyperv.box) {
        Remove-Item -Path .\windows_11_hyperv.box
    }
}

function Init {
    Clear-PreviousBuild
    Invoke-Packer
}

Init