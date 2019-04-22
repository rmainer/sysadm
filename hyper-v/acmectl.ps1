#Requires -RunAsAdministrator

Param (
    [Parameter(Mandatory=$true)]
    [string]$command
)

$hosts = @(
    "acme-server-master",
    "acme-server-slave",
    "acme-client-1",
    "acme-client-2"
);

if($command -ieq "start") {
    Get-VM | ForEach-Object {
        if($hosts.Contains($_.Name) -and $_.State -eq "Off") { 
            Write-Output "Starting $($_.Name)"
            Start-VM -Name $_.Name; 
        }
    }
} 
elseif ($command -ieq "Stop") {
    Get-VM | ForEach-Object {
        if($hosts.Contains($_.Name) -and $_.State -eq "Running") { 
            Write-Output "Stopping $($_.Name)"
            Stop-VM -Name $_.Name; 
        }
    }   
} 
else { 
    Write-Output "Unknow command!"
    exit 0
 }