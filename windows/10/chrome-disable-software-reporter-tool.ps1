# Disables software_reporter_tool.exe from Google Chrome

$path = Join-Path $env:USERPROFILE "AppData\Local\Google\Chrome\User Data\SwReporter"

if (Test-Path $path)
{
    $acl = Get-ACL -Path $path
    $acl.SetAccessRuleProtection($True, $True)
    Set-Acl -Path $path -AclObject $acl
}