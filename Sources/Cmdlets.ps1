using namespace System.Diagnostics.CodeAnalysis
using namespace System.Net.Http
using namespace System.Text
using module ./Author.psm1
using module ./Blog.psm1
using module ./CheckResult.psm1
using module ./Client.psm1
using module ./Comment.psm1

<#
.SYNOPSIS
	Creates a new author.
.OUTPUTS
	The newly created author.
#>
function New-AkismetAuthor {
	[CmdletBinding()]
	[OutputType([Author])]
	param (
		# The author's IP address.
		[Parameter(Mandatory)]
		[ipaddress] $IPAddress,

		# The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `$true`.
		[Parameter(Position = 0)]
		[ValidateNotNull()]
		[string] $Name = "",

		# The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `$true`.
		[ValidateNotNull()]
		[string] $Email = "",

		# The author's role. If you set it to `"administrator"`, Akismet will always return `$false`.
		[ValidateNotNull()]
		[string] $Role = "",

		# The URL of the author's website.
		[uri] $Url,

		# The author's user agent, that is the string identifying the Web browser used to submit comments.
		[ValidateNotNull()]
		[string] $UserAgent = ""
	)

	$author = [Author] $IPAddress
	$author.Email = $Email
	$author.Name = $Name
	$author.Role = $Role
	$author.Url = $Url
	$author.UserAgent = $UserAgent
	$author
}

<#
.SYNOPSIS
	Creates a new blog.
.OUTPUTS
	The newly created blog.
#>
function New-AkismetBlog {
	[CmdletBinding()]
	[OutputType([Blog])]
	param (
		# The blog or site URL.
		[Parameter(Mandatory, Position = 0)]
		[uri] $Url,

		# The character encoding for the values included in comments.
		[ValidateScript({
			$charset = $_
			[string]::IsNullOrEmpty($charset) -or [Encoding].GetEncodings().Where({ $_.Name -eq $charset }, "First").Count
		}, ErrorMessage = "The specified character encoding is unknown.")]
		[string] $Charset,

		# The languages in use on the blog or site, in ISO 639-1 format.
		[ValidateNotNull()]
		[string[]] $Languages = @()
	)

	$blog = [Blog] $Url
	$blog.Charset = $Charset ? [Encoding]::GetEncoding($Charset) : $null
	$blog.Languages = $Languages
	$blog
}

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

<#
.SYNOPSIS
	Creates a new comment.
.OUTPUTS
	The newly created comment.
#>
function New-AkismetComment {
	[CmdletBinding()]
	[OutputType([Comment])]
	param (
		# The comment's author.
		[Parameter(Mandatory)]
		[Author] $Author,

		# The comment's content.
		[Parameter(Position = 0)]
		[ValidateNotNull()]
		[string] $Content = "",

		# The context in which this comment was posted.
		[ValidateNotNull()]
		[string[]] $Context = @(),

		# The UTC timestamp of the creation of the comment.
		[datetime] $Date,

		# The permanent location of the entry the comment is submitted to.
		[uri] $Permalink,

		# The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
		[datetime] $PostModified,

		# A string describing why the content is being rechecked.
		[ValidateNotNull()]
		[string] $RecheckReason = "",

		# The URL of the webpage that linked to the entry being requested.
		[uri] $Referrer,

		# The comment's type.
		[ValidateNotNull()]
		[string] $Type = ""
	)

	$comment = [Comment] $Author
	$comment.Content = $Content
	$comment.Context = $Context
	$comment.Date = $Date
	$comment.Permalink = $Permalink
	$comment.PostModified = $PostModified
	$comment.RecheckReason = $RecheckReason
	$comment.Referrer = $Referrer
	$comment.Type = $Type
	$comment
}

<#
.SYNOPSIS
	Submits the specified comment that was incorrectly marked as spam but should not have been.
.INPUTS
	The comment to be submitted.
#>
function Submit-AkismetHam {
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

<#
.SYNOPSIS
	Submits the specified comment that was not marked as spam but should have been.
.INPUTS
	The comment to be submitted.
#>
function Submit-AkismetSpam {
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
		try { $Client.SubmitSpam($Comment) }
		catch [HttpRequestException] { Write-Error $_.Exception }
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
function Test-AkismetApiKey {
	[CmdletBinding()]
	[OutputType([bool])]
	param (
		# The Akismet API key.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[string] $ApiKey,

		# The front page or home URL of the instance making requests.
		[Parameter(Mandatory)]
		[Blog] $Blog
	)

	process {
		try { [Client]::new($ApiKey, $Blog).VerifyKey() }
		catch [HttpRequestException] { Write-Error $_.Exception }
	}
}

<#
.SYNOPSIS
	Checks the specified comment against the service database, and returns a value indicating whether it is spam.
.INPUTS
	The comment to be submitted.
.OUTPUTS
	A value indicating whether the specified comment is spam.
#>
function Test-AkismetComment {
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
