#clear-host
#Remove-Variable * -ErrorAction SilentlyContinue

param ($mountpath)


#Create Variables
$ScriptLocation = "e:\scripts"
$databaselistfile = "$ScriptLocation\databaselist.txt"


$config = ""
$smo = ""

#remove-item C:\Scripts\databases.txt
remove-item $databaselistfile -ErrorAction SilentlyContinue
remove-item "e:\Scripts\error-log.txt" -ErrorAction SilentlyContinue

Set-Location e:\Scripts

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

$dbs = (Get-SqlDatabase -ServerInstance $config.sql.Server).name

Get-ChildItem -Path $mountpath -Recurse -include *.mdf | ForEach-Object {
 if ($_.Extension -eq ".mdf") {
          $mdfFile = Get-Item -Path $_.FullName
          $mdfFileName = $mdfFile.Name
          $mdf=$_.fullname
          $dbname=$_.BaseName
            }
    #write-host $dbname
    $ldf = (Get-ChildItem -Path $mountpath -Recurse -include *.ldf | Where-Object {$_.Name -eq "$dbname.ldf"}).Fullname
    #write-host $ldf

    $files = New-Object System.Collections.Specialized.StringCollection
    $files.add($mdf) | Out-Null
    $files.add($ldf) | Out-Null
    
    $dbname | out-file $databaselistfile -Append
    
try {
       #Write-Host $dbs
       if ($dbs -notcontains $DBName)
        {
         write-host "Attaching database $dbname"
        $smo.AttachDatabase($DBName, $files);
        }
    }

catch
    {
    write-host $_.Exception;
    if ($error.Count -gt 0)
        {
        write-host "Error Information";
        $error[0] | fl -force | out-file C:\Scripts\error-log.txt
        }
    }
    
    
    
    
}


}

