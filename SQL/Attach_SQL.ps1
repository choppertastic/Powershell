clear-host
Remove-Variable * -ErrorAction SilentlyContinue
Set-Location C:\Scripts

#Import SQL Powershell
import-module sqlps
$config = ""
$smo = ""
$files = ""
# Load configuration XML file.
[xml]$config = Get-Content "DatabasesConfig.xml"

#Connect to SQL
$smo = New-Object Microsoft.SqlServer.Management.Smo.Server $config.SQL.Server
$smo.ConnectionContext.LoginSecure = $false
$smo.ConnectionContext.Login = $config.SQL.Credentials.Login
$smo.ConnectionContext.Password = $config.SQL.Credentials.Password
$smo.ConnectionContext.Connect()


    Get-ChildItem -Path "e:\mount" -Recurse | Where-Object {($_.Extension -eq ".mdf") -or ($_.Extension -eq ".ldf")} | ForEach-Object {
  #  Get-ChildItem -Path "e:\mount" -Recurse | ForEach-Object {
       
        if ($_.Extension -eq ".ldf") {
          $LdfFile = Get-Item -Path $_.FullName
          $LdfFileName = $LdfFile.Name
       write-host "LDF FILE"  $LdfFile
       Write-Host "LDF FILE NAME"  $LdfFileName
       }


       if ($_.Extension -eq ".mdf") {
          $mdfFile = Get-Item -Path $_.FullName
          $mdfFileName = $mdfFile.Name
          $DBName = $mdfFile.basename

        write-host "MDF FILE"  $mdfFile
        Write-Host "MDF FILE NAME"  $mdfFileName
        write-host "Database"  $DBName

       }
      
       
       
      $files = New-Object System.Collections.Specialized.StringCollection
      $files.add($mdffile) | Out-Null
      $files.add($ldfFile) | Out-Null
      write-host "FILES   "  $files


       # write-host $DBName
       # Write-Host $mdfFile
       # Write-Host $ldfFile
       
#        write-host $files

       # $smo.AttachDatabase($DBName, $files)
          
       }
        
        
       





      #  Write-Host $mdfFileName
       # Write-Host $LogFileName
       # Write-host "DB Name" + $DBName
 #   }


