$vmName = (Get-VM | Where-Object { $_.Name.Contains("vagrant-development-environments")}).Name
vmconnect.exe $env:COMPUTERNAME $vmName