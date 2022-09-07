clear-host
Remove-Variable * -ErrorAction SilentlyContinue

#Create Variables
$ScriptLocation = "c:\scripts"
$databaselistfile = "$ScriptLocation\databaselist.txt"
$mountpath = "e:\mount"

$config = ""
$smo = ""

#remove-item C:\Scripts\databases.txt
remove-item $databaselistfile

Set-Location C:\Scripts

#Import SQL Powershell
import-module sqlps

# Load configuration XML file.
[xml]$config = Get-Content "DatabasesConfig.xml"

#Connect to SQL
$smo = New-Object Microsoft.SqlServer.Management.Smo.Server $config.SQL.Server
$smo.ConnectionContext.LoginSecure = $false
$smo.ConnectionContext.Login = $config.SQL.Credentials.Login
$smo.ConnectionContext.Password = $config.SQL.Credentials.Password
$smo.ConnectionContext.Connect()

Get-ChildItem -Path $mountpath -Recurse -include *.mdf | ForEach-Object {
 if ($_.Extension -eq ".mdf") {
          $mdfFile = Get-Item -Path $_.FullName
          $mdfFileName = $mdfFile.Name
          $mdf=$_.fullname
          $dbname=$_.BaseName
            }

    $ldf = (Get-ChildItem -Path $mountpath -Recurse -include *.ldf | Where-Object {$_.Name -like "*$dbname*"}).Fullname

    $files = New-Object System.Collections.Specialized.StringCollection
    $files.add($mdf) | Out-Null
    $files.add($ldf) | Out-Null
    #write-host $dbname + $files
    $dbname | out-file $databaselistfile -Append
    

$smo.AttachDatabase($DBName, $files)
    }

