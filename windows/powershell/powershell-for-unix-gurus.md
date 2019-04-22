# PowerShell for Unix Gurus

Unix | Windows | Alias
--- | --- | ---
`alias` | `Get-Alias` |
`cat` | `Get-Content` |
`cd` | `Set-Location` | `cd`
`echo` | `Write-Output` | `echo`
`find` | `Get-ChildItem` | 
`grep` | `Select-String` | 
`ls` | `Get-ChildItem` | `ls`
`man` | `Get-Help` |
`md5sum` | `Get-FileHash -Algorithm MD5` |
`ps` | `Get-Process` | `ps`
`pwd` | `Get-Location` | `pwd`
`rm` | `Remove-Item` | `rm`
`sha256sum` | `Get-FileHash -Algorithm SHA256` |
`which <cmd>` | `Get-Command <cmd> | Select -ExpandProperty Path` |

## Use cases

Unix | Windows
--- | ---
`echo $USER` | `Write-Output $env:USERNAME`
`find . -type d` |  `Get-ChildItem -Recurse -Directory`
`find . -type f -name '*.tex' | grep 'TODO'` | `Get-ChildItem -Recurse -Path . -File -Filter '*.tex' | Select-String -CaseSensitive 'TODO'`

## User configuration (.bashrc)

* File: `C:\Users\<USER>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

```powershell
# Path
$env:Path += ";C:\Program Files\gnuplot\bin"

# Aliases
Set-Alias -Name '~' -Value $env:HOMEPATH

function MyAliasCD { Set-Location '..' }
Set-Alias -Name '..' -Value MyAliasCD

function MyAliasExit { exit }
Set-Alias ^D MyAliasExit

function which($cmd) { Get-Command $cmd | Select -ExpandProperty Path }

# Modules
Import-Module DockerCompletion
Import-Module posh-git
```

## Useful variables

* Home directory: `$env:HOMEPATH`
* Path variable: `$PATH`
* Profile file: `$PROFILE`
* User name: `$env:USERNAME`
