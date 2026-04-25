using namespace System.Diagnostics.CodeAnalysis
Import-Module "$PSScriptRoot/../../Akismet.psd1"

# The client used to query the remote API.
[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
$client = New-AkismetClient -ApiKey $Env:AKISMET_API_KEY -Blog "https://github.com/cedx/akismet.ps1" -WhatIf

# A comment with content marked as ham.
$ham = New-AkismetComment @{
	Author = New-AkismetAuthor @{
		IPAddress = "192.168.0.1"
		Name = "Akismet"
		Role = "administrator"
		Url = "https://cedric-belin.fr"
		UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36"
	}
	Content = "I'm testing out the Service API."
	Referrer = "https://www.powershellgallery.com/packages/Belin.Akismet"
	Type = "comment"
}

# A comment with content marked as spam.
$spam = New-AkismetComment @{
	Author = New-AkismetAuthor @{
		Email = "akismet-guaranteed-spam@example.com"
		IPAddress = "127.0.0.1"
		Name = "viagra-test-123"
		UserAgent = "Spam Bot/6.6.6"
	}
	Content = "Spam!"
	Date = Get-Date
	Type = "blog-post"
}
