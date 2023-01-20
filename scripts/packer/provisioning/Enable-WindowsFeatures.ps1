$features = @(
    'IIS-WebServer',
    'IIS-CommonHttpFeatures',
    'IIS-HttpErrors',
    'IIS-HttpRedirect',
    'IIS-ApplicationDevelopment',
    'IIS-Security',
    'IIS-RequestFiltering',
    'IIS-NetFxExtensibility',
    'IIS-NetFxExtensibility45',
    'IIS-HealthAndDiagnostics',
    'IIS-HttpLogging',
    'IIS-Performance',
    'IIS-WebServerManagementTools',
    'WCF-Services45',
    'WCF-TCP-PortSharing45',
    'IIS-StaticContent',
    'IIS-DefaultDocument',
    'IIS-DirectoryBrowsing',
    'IIS-WebDAV',
    'IIS-WebSockets',
    'IIS-ApplicationInit',
    'IIS-ISAPIFilter',
    'IIS-ISAPIExtensions',
    'IIS-ASPNET',
    'IIS-ASPNET45',
    'IIS-ASP',
    'IIS-CGI',
    'IIS-ServerSideIncludes',
    'IIS-HttpCompressionStatic',
    'IIS-ManagementConsole'
)

Enable-WindowsOptionalFeature -FeatureName $features -All -Online -NoRestart