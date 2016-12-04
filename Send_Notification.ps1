param([string]$EmailList,[string]$To,[string]$Notification,[switch]$help)
	
if($help)
{
	Write-Host "Usage: Send-Email -To [Recipient(s)Name] -Subject [string] -Body [string]"
}

$To = (get-qaduser $To).email
$VerifyTo = read-host Send email to: $To? [yes/no]

if($VerifyTo -eq "Yes" -OR "y")
{
	$Outlook = New-Object -ComObject Outlook.Application
	$Mail = $Outlook.CreateItem(0)
	$Mail.SendOnBehalfOfName
	$Mail.Recipients.Add($To)
	$Mail.Recipients.Add($To).BCC
	$Mail.Subject = $Subject
	$Mail.Body = $Body
	$Mail.Send()
}