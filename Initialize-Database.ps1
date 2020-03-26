
param(
[Parameter(Mandatory=$false)]
[string]$sa_password,

[Parameter(Mandatory=$false)]
[string]$db_name,

[Parameter(Mandatory=$false)]
[string]$data_path
)

# start the service
Write-Verbose "Starting SQL Server"

start-service MSSQL`$SQLEXPRESS


if($sa_password -ne "_")
{
    Write-Verbose "Changing SA login credentials"
    $sqlcmd = "ALTER LOGIN sa with password=" +"'" + $sa_password + "'" + ";ALTER LOGIN sa ENABLE;"
    & sqlcmd -Q $sqlcmd
}

$mdfPath = "$data_path\$db_name.mdf"
$ldfPath = "$data_path\$db_name.ldf"

# ----

if ((Test-Path $mdfPath) -eq $true) {
    $sqlcmd = "IF DB_ID('$db_name') IS NULL BEGIN CREATE DATABASE MSSQLDB ON (FILENAME = N'$mdfPath')"
    if ((Test-Path $ldfPath) -eq $true) {
        $sqlcmd = "$sqlcmd, (FILENAME = N'$ldfPath')"
    }
    $sqlcmd = "$sqlcmd FOR ATTACH; END"
    Write-Verbose 'Data files exists = will attach and upgrade database'
} else {
    Write-Verbose 'No data files = will create a new database'
}



$SqlPackagePath = 'C:\\Program Files\\Microsoft SQL Server\\150\\DAC\\bin\\SqlPackage.exe'

& $SqlPackagePath `
    /sf:$db_name.dacpac `
    /a:script /op:deploy.sql /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:$db_name /tu:sa /tp:$sa_password

$SqlCmdVars = "DatabaseName=$db_name", "DefaultFilePrefix=$db_name", "DefaultDataPath=$data_path\", "DefaultLogPath=$data_path\"
Invoke-SqlCmd -InputFile deploy.sql -Variable $SqlCmdVars -Verbose

Write-Verbose "Deployed MSSQLDB database, data files at: $data_path"

# ----

$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}