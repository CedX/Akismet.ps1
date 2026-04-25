using namespace Microsoft.PowerShell.Commands
using namespace System.Collections.Generic
using namespace System.Net.Http
using module ./Blog.psm1
using module ./CheckResult.psm1
using module ./Cmdlets/Get-Version.psm1
using module ./Comment.psm1

<#
.SYNOPSIS
	The response returned by the `submit-ham` and `submit-spam` endpoints when the outcome is a success.
#>
[string] $Success = "Thanks for making the web a better place."

<#
.SYNOPSIS
	Submits comments to the Akismet service.
#>
class Client {

	<#
	.SYNOPSIS
		The Akismet API key.
	#>
	[ValidateNotNull()]
	[string] $ApiKey = ""

	<#
	.SYNOPSIS
		The base URL of the remote API endpoint.
	#>
	[ValidateNotNull()]
	[uri] $BaseUrl

	<#
	.SYNOPSIS
		The front page or home URL of the instance making requests.
	#>
	[ValidateNotNull()]
	[Blog] $Blog

	<#
	.SYNOPSIS
		Value indicating whether the client operates in test mode.
	#>
	[bool] $IsTest

	<#
	.SYNOPSIS
		The user agent string to use when making requests.
	#>
	[ValidateNotNullOrWhiteSpace()]
	[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Belin.Akismet/$(Get-Version)"

	<#
	.SYNOPSIS
		Creates a new client.
	.PARAMETER ApiKey
		The Akismet API key.
	.PARAMETER Blog
		The front page or home URL of the instance making requests.
	#>
	Client([string] $ApiKey, [Blog] $Blog) {
		$this.ApiKey = $ApiKey
		$this.BaseUrl = "https://rest.akismet.com/"
		$this.Blog = $Blog
	}

	<#
	.SYNOPSIS
		Creates a new client.
	.PARAMETER ApiKey
		The Akismet API key.
	.PARAMETER Blog
		The front page or home URL of the instance making requests.
	.PARAMETER BaseUrl
		The base URL of the remote API endpoint.
	#>
	Client([string] $ApiKey, [Blog] $Blog, [uri] $BaseUrl) {
		$this.ApiKey = $ApiKey
		$this.BaseUrl = $BaseUrl
		$this.Blog = $Blog
	}

	<#
	.SYNOPSIS
		Checks the specified comment against the service database, and returns a value indicating whether it is spam.
	.PARAMETER Comment
		The comment to be submitted.
	.OUTPUTS
		A value indicating whether the specified comment is spam.
	#>
	[CheckResult] CheckComment([Comment] $Comment) {
		$response = $this.Fetch("1.1/comment-check", [hashtable] $Comment)
		if ($response.Content -eq "false") { return [CheckResult]::Ham }

		$messages = [List[string]]::new()
		if (-not $response.Headers.TryGetValue("X-akismet-pro-tip", [ref] $messages)) { return [CheckResult]::Spam }
		return $messages[0] -eq "discard" ? [CheckResult]::PervasiveSpam : [CheckResult]::Spam
	}

	<#
	.SYNOPSIS
		Submits the specified comment that was incorrectly marked as spam but should not have been.
	.PARAMETER Comment
		The comment to be submitted.
	#>
	[void] SubmitHam([Comment] $Comment) {
		$response = $this.Fetch("1.1/submit-ham", [hashtable] $Comment)
		if ($response.Content -ne $Script:Success) { throw [HttpRequestException] "Invalid server response." }
	}

	<#
	.SYNOPSIS
		Submits the specified comment that was not marked as spam but should have been.
	.PARAMETER Comment
		The comment to be submitted.
	#>
	[void] SubmitSpam([Comment] $Comment) {
		$response = $this.Fetch("1.1/submit-spam", [hashtable] $Comment)
		if ($response.Content -ne $Script:Success) { throw [HttpRequestException] "Invalid server response." }
	}

	<#
	.SYNOPSIS
		Checks the API key against the service database, and returns a value indicating whether it is valid.
	.OUTPUTS
		`$true` if the specified API key is valid, otherwise `$false`.
	#>
	[bool] VerifyKey() {
		return $this.Fetch("1.1/verify-key", @{}).Content -eq "valid"
	}

	<#
	.SYNOPSIS
		Queries the service by posting the specified fields to a given end point, and returns the response.
	.PARAMETER EndPoint
		The relative URL of the end point to query.
	.PARAMETER Fields
		The fields describing the query body.
	.OUTPUTS
		The server response.
	#>
	hidden [BasicHtmlWebResponseObject] Fetch([string] $EndPoint, [hashtable] $Fields) {
		$body = [hashtable] $this.Blog
		$body.api_key = $this.ApiKey
		if ($this.IsTest) { $body.is_test = "1" }
		if ($Fields.Count) { foreach ($key in $Fields.Keys) { $body.$key = $Fields.$key } }

		$messages = [List[string]]::new()
		$response = Invoke-WebRequest ([uri]::new($this.BaseUrl, $EndPoint)) -Method Post -Body $body -UserAgent $this.UserAgent
		if ($response.Headers.TryGetValue("X-akismet-alert-msg", [ref] $messages)) { throw [HttpRequestException] $messages[0] }
		if ($response.Headers.TryGetValue("X-akismet-debug-help", [ref] $messages)) { throw [HttpRequestException] $messages[0] }
		return $response
	}
}
