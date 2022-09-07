Set-Location $PSScriptRoot

$ScriptLocation = "c:\scripts"
$databaselistfile = "$ScriptLocation\databaselist.txt"

#Import SQL Powershell
import-module sqlps

# Load configuration XML file.
[xml]$config = Get-Content "DatabasesConfig.xml"
$databases = Get-Content $databaselistfile


#Connect to SQL
$smo = New-Object Microsoft.SqlServer.Management.Smo.Server $config.SQL.Server
$smo.ConnectionContext.LoginSecure = $false
$smo.ConnectionContext.Login = $config.SQL.Credentials.Login
$smo.ConnectionContext.Password = $config.SQL.Credentials.Password
$smo.ConnectionContext.Connect()


ForEach ($database in $databases)
{
    $DBName = $database
    
    $smo.KillAllProcesses($DBName)
    $smo.DetachDatabase($DBName, $false)
}
