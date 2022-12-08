$mountedSqlServerMedia = Mount-DiskImage "C:/temp/sqlserver_2019.iso";

$mountedSqlServerMediaDrive = (($mountedSqlServerMedia | Get-Volume).DriveLetter + ":/")

Write-Host "Installing SQL Server"
& "$mountedSqlServerMediaDrive/setup.exe" /Q /IACCEPTSQLSERVERLICENSETERMS /ACTION="install" /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /SECURITYMODE="SQL" /SQLSVCACCOUNT="NT AUTHORITY\Network Service" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" /SQLSYSADMINACCOUNTS="vagrant" /SAPWD="vagrant"
