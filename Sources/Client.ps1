using namespace Belin.Akismet
using namespace System.Diagnostics.CodeAnalysis
using namespace System.Net.Http

<#
.SYNOPSIS
	The module version.
#>
[semver] $Script:Version = & {
	$path = "$PSScriptRoot/../Belin.Akismet.psd1"
	(Import-PowerShellDataFile ((Test-Path $path) ? $path : "$PSScriptRoot/../Akismet.psd1")).ModuleVersion
}

<#
.SYNOPSIS
	Creates a new Akismet client.
.OUTPUTS
	The newly created client.
#>
function New-Client {
	[CmdletBinding()]
	[OutputType([Belin.Akismet.Client])]
	[SuppressMessage("PSUseSupportsShouldProcess", "")]
	param (
		# The Akismet API key.
		[Parameter(Mandatory, Position = 1)]
		[string] $ApiKey,

		# The front page or home URL of the instance making requests.
		[Parameter(Mandatory)]
		[Blog] $Blog,

		# The user agent string to use when making requests.
		[ValidateNotNullOrWhiteSpace()]
		[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Belin.Akismet/$Script:Version",

		# The base URL of the remote API endpoint.
		[ValidateNotNull()]
		[uri] $Uri = "https://rest.akismet.com/",

		# Value indicating whether the client operates in test mode.
		[switch] $WhatIf
	)

	$client = [Client]::new($ApiKey, $Blog)
	$client.BaseUrl = $Uri
	$client.IsTest = $WhatIf
	$client.UserAgent = $UserAgent
	$client
}

<#
.SYNOPSIS
	Submits the specified comment that was incorrectly marked as spam but should not have been.
.INPUTS
	The comment to be submitted.
#>
function Submit-Ham {
	[CmdletBinding()]
	[OutputType([void])]
	param (
		# The comment to be submitted.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Comment] $Comment,

		# The Akismet client used to submit the comment.
		[Parameter(Mandatory)]
		[Client] $Client
	)

	process {
		try { $Client.SubmitHam($Comment) }
		catch [HttpRequestException] { Write-Error $_ }
	}
}

<#
.SYNOPSIS
	Submits the specified comment that was not marked as spam but should have been.
.INPUTS
	The comment to be submitted.
#>
function Submit-Spam {
	[CmdletBinding()]
	[OutputType([void])]
	param (
		# The comment to be submitted.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Comment] $Comment,

		# The Akismet client used to submit the comment.
		[Parameter(Mandatory)]
		[Client] $Client
	)

	process {
		try { $Client.SubmitSpam($Comment) }
		catch [HttpRequestException] { Write-Error $_ }
	}
}

<#
.SYNOPSIS
	Checks the API key against the service database, and returns a value indicating whether it is valid.
.INPUTS
	The Akismet API key.
.OUTPUTS
	`$true` if the specified API key is valid, otherwise `$false`.
#>
function Test-ApiKey {
	[CmdletBinding()]
	[OutputType([bool])]
	param (
		# The Akismet API key.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[string] $ApiKey,

		# The front page or home URL of the instance making requests.
		[Parameter(Mandatory)]
		[Blog] $Blog
	)

	process {
		try { [Client]::new($ApiKey, $Blog).VerifyKey() }
		catch [HttpRequestException] { Write-Error $_ }
	}
}
