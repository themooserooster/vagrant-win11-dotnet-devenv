param(
    [switch]$Debug = $false,
    [string][ValidateSet("HyperV", "Virtualbox")][Parameter(Mandatory = $true)]$ProviderFormat
)

$ErrorActionPreference = 'Stop'

function Invoke-Packer {
    if ($Debug) {
        $env:PACKER_LOG=1
        $env:PACKER_LOG_PATH=".\packerlog.txt"
    }
    
    try {
        packer build ./($ProviderFormat.ToLower())
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

    if (Test-Path -Path .\($ProviderFormat.ToLower())\windows_11.box) {
        Remove-Item -Path .\($ProviderFormat.ToLower())\windows_11.box
    }
}

function Init {
    Clear-PreviousBuild
    Invoke-Packer
}

Init