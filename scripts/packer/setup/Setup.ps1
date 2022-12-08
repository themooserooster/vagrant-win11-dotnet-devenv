function Install-PSPackageManagement {
    Write-Host "Installing Nuget package provider..."
    Install-PackageProvider -Name NuGet -Force

    Write-Host "Setting PSGallery as trusted"
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

    Install-Module SqlServer
    Install-Module PSWindowsUpdate
}

function Disable-UAC {
    Write-Output "Disabling UAC"
    Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
}

function Install-ChocolateyPackageManager {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Disable-ScreenSaver {
    Write-Output "Disabling Screensaver"
    Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
    & powercfg -x -monitor-timeout-ac 0
    & powercfg -x -monitor-timeout-dc 0
}

function Disable-Hibernation {
    # Zero Hibernation File
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
    # Disable Hibernation Mode
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
}

function Disable-PasswordExpiration {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]
        $User
    )

    Set-LocalUser -Name $User -PasswordNeverExpires 1
}

function Enable-AutoLogon {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $DefaultUsername,
        [Parameter(Mandatory, Position=1)]
        [string]
        $DefaultPassword
    )

    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
}

function Install-Ssh {
    # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }

    Write-Output "Installing OpenSSH client and server..."
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Write-Output "OpenSSH client and server successfully installed."

    # Install Vagrant default insecure key so provisioning works:
    Write-Output "Installing Vagrant default insecure SSH key..."
    New-Item -ItemType 'Directory' -Path '~\' -Name '.ssh' -Force
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -OutFile ~\.ssh\authorized_keys
    Write-Output "Vagrant default insecure SSH key successfully installed."

    Write-Output "Starting SSH services..."
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'

    Start-Service ssh-agent
    Set-Service -Name ssh-agent -StartupType 'Automatic'

    Write-Output "SSH services set to automatic startup and running."
}

function Enable-WinRm {
    # # You cannot enable Windows PowerShell Remoting on network connections that are set to Public
    # # Spin through all the network locations and if they are set to Public, set them to Private

    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

    Enable-PSRemoting -SkipNetworkProfileCheck -Force
}

function Init {
    Disable-PasswordExpiration -User "vagrant"
    Enable-AutoLogon -DefaultUsername "vagrant" -DefaultPassword "vagrant"
    Disable-UAC
    Disable-ScreenSaver
    Enable-WinRm
    Install-PSPackageManagement
    Install-ChocolateyPackageManager
    Install-Ssh
}

Init