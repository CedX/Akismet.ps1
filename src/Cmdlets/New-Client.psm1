using namespace System.Diagnostics.CodeAnalysis
using module ../Blog.psm1
using module ../Client.psm1

<#
.SYNOPSIS
	Creates a new Akismet client.
.OUTPUTS
	The newly created client.
#>
function New-AkismetClient {
	[CmdletBinding()]
	[OutputType([Client])]
	[SuppressMessage("PSUseSupportsShouldProcess", "")]
	param (
		# The Akismet API key.
		[Parameter(Mandatory, Position = 0)]
		[string] $ApiKey,

		# The front page or home URL of the instance making requests.
		[Parameter(Mandatory)]
		[Blog] $Blog,

		# The user agent string to use when making requests.
		[ValidateNotNullOrWhiteSpace()]
		[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Belin.Akismet/$([Client]::Version)",

		# The base URL of the remote API endpoint.
		[ValidateNotNull()]
		[uri] $Uri = "https://rest.akismet.com/",

		# Value indicating whether the client operates in test mode.
		[switch] $WhatIf
	)

	$client = [Client]::new($ApiKey, $Blog, $Uri)
	$client.IsTest = $WhatIf
	$client.UserAgent = $UserAgent
	$client
}
