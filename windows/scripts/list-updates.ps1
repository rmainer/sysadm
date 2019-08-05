<#
.Synopsis
Lists all Windows Updates 

.DESCRIPTION
This script lists all Windows Updates (hotfixes, function updates, etc.), but ignores definition updates for the Windows Defender.
	
.NOTES
You may also use "Get-HotFix", "wmic qfe list" or "Get-WmiObject -class win32_quickfixengineering", but you won't get all updates, see:
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-hotfix?view=powershell-5.1#notes

.EXAMPLE
PS> .\list-updates.ps1
#>


function Convert-WuaResultCodeToName
{
	param(
		[Parameter(Mandatory=$true)][int] $ResultCode
	)
	$Result = $ResultCode
	switch($ResultCode) {
		0 { $Result = "Not Started" }
		1 { $Result = "In Progress" }
		2 { $Result = "Succeeded" }
		3 { $Result = "Succeeded With Errors" }
		4 { $Result = "Failed" }
		5 { $Result = "Aborted" }
	}
	return $Result
}

function Get-WuaHistory {
	$Session = New-Object -ComObject 'Microsoft.Update.Session'
	$Searcher = $Session.CreateUpdateSearcher()
	$HistoryCount = $Searcher.GetTotalHistoryCount()
	$History = $Session.QueryHistory("", 0, $HistoryCount) | ForEach-Object {
		$Result = Convert-WuaResultCodeToName -ResultCode $_.ResultCode
		$_ | Add-Member -MemberType NoteProperty -Value $Result -Name Result
		$KB = [regex]::Match($_.Title, 'KB(\d+)')
		$_ | Add-Member -MemberType NoteProperty -Name KB -Value $KB
		$KBUrl = if ($KB.Success -eq $true) { "http://support.microsoft.com/?kbid=" + $KB.Captures.Groups[1].Value } else { "" }
		$_ | Add-Member -MemberType NoteProperty -Name KBUrl -Value $KBUrl
		$Product = $_.Categories | Where-Object {$_.Type -eq 'Product'} | Select-Object -First 1 -ExpandProperty Name
		$_ | Add-Member -MemberType NoteProperty -Value $_.UpdateIdentity.UpdateId -Name UpdateId
		$_ | Add-Member -MemberType NoteProperty -Value $_.UpdateIdentity.RevisionNumber -Name RevisionNumber
		$_ | Add-Member -MemberType NoteProperty -Value $Product -Name Product -PassThru
		Write-Output $_
	}

	$History |
		Where-Object { ![String]::IsNullOrWhiteSpace($_.Title) -and $_.Product -ne "Windows Defender" } |
		Select-Object Result, Date, KB, Title, SupportUrl, KBUrl, Product, UpdateId, RevisionNumber
}

Get-WuaHistory #| Format-Table