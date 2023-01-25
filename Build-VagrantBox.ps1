param(
    [string]
    [ValidateSet("HyperV", "Virtualbox")]
    [Parameter(Mandatory = $true)]
    $ProviderFormat
)

$ErrorActionPreference = 'Stop'

function Invoke-Packer {
    $env:PACKER_LOG=1
    $env:PACKER_LOG_PATH=".\packerlog.txt"
    
    try {
        Write-Host "Building for provider $ProviderFormat..."
        packer build -force "./$($ProviderFormat.ToLower())"
    }
    catch {
        Write-Error "Packer experienced an error. Cancelling Vagrant box build..."
        Write-Error $_
    }
}

function Clear-PreviousBuild {
    if (Test-Path -Path .\output-windows11) {
        Remove-Item -Path .\output-windows11 -Recurse -Force
    }

    if (Test-Path -Path .vagrant) {
        Remove-Item -Path .vagrant -Recurse -Force
    }

    if (Test-Path -Path .\windows11*.box) {
        Remove-Item -Path .\windows11*.box
    }
}

function Init {
    Clear-PreviousBuild
    Invoke-Packer
}

Init