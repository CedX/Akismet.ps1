using namespace System.Net.Http
using module ../CheckResult.psm1
using module ../Client.psm1
using module ../Comment.psm1

<#
.SYNOPSIS
	Checks the specified comment against the service database, and returns a value indicating whether it is spam.
.INPUTS
	The comment to be submitted.
.OUTPUTS
	A value indicating whether the specified comment is spam.
#>
function Test-Comment {
	[CmdletBinding()]
	[OutputType([CheckResult])]
	param (
		# The comment to be submitted.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[Comment] $Comment,

		# The Akismet client used to submit the comment.
		[Parameter(Mandatory)]
		[Client] $Client
	)

	process {
		try { $Client.CheckComment($Comment) }
		catch [HttpRequestException] { Write-Error $_.Exception }
	}
}
