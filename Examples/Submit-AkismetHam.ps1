<#
.SYNOPSIS
	Submits ham to the Akismet service.
#>
using module Belin.Akismet

$author = New-AkismetAuthor -IPAddress "192.168.0.1" -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:156.0) Gecko/20100101 Firefox/156.0"
$comment = New-AkismetComment "I'm testing out the Service API." -Author $author

$client = New-AkismetClient -ApiKey "123YourAPIKey" -Blog "https://www.yourblog.com"
Submit-AkismetHam -Client $client -Comment $comment
Write-Output "The comment was successfully submitted as ham."
