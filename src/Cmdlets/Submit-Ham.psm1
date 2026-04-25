using namespace System.Net.Http
using module ../Client.psm1
using module ../Comment.psm1

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
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[Comment] $Comment,

		# The Akismet client used to submit the comment.
		[Parameter(Mandatory)]
		[Client] $Client
	)

	process {
		try { $Client.SubmitHam($Comment) }
		catch [HttpRequestException] { Write-Error $_.Exception }
	}
}
