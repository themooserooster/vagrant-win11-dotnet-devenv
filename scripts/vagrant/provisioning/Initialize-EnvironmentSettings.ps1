param(
    [Parameter(Position = 0, Mandatory)][string]$WindowsKey,
    [Parameter(Position = 1, Mandatory)][string]$VisualStudioKey,
    [Parameter(Position = 4, Mandatory)][string]$DevEnvUserFullName,
    [Parameter(Position = 5, Mandatory)][string]$DevEnvUserEmail
)

Write-Host "Activating Windows..."
slmgr.vbs /ipk $WindowsKey
slmgr /ato
Write-Host "Windows activated."

Write-Host "Configuring global Git user..."
git config --global user.name "$DevEnvUserFullName"
git config --global user.email "$DevEnvUserEmail"
Write-Host "Global Git user configured."