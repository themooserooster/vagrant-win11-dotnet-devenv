Write-Host "Deactivating Windows..."
slmgr.vbs /upk
slmgr /cpky
Write-Host "Windows deactivated."