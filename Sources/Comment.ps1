using namespace Belin.Akismet
using namespace System.Net.Http

<#
.SYNOPSIS
	Creates a new comment.
.OUTPUTS
	The newly created comment.
#>
function New-Comment {
	[CmdletBinding()]
	[OutputType([Belin.Akismet.Comment])]
	param (
		# The comment's author.
		[Parameter(Mandatory)]
		[Author] $Author,

		# The comment's content.
		[Parameter(Position = 1)]
		[ValidateNotNull()]
		[string] $Content,

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
		[string] $RecheckReason,

		# The URL of the webpage that linked to the entry being requested.
		[uri] $Referrer,

		# The comment's type.
		[ValidateNotNull()]
		[string] $Type
	)

	$comment = [Comment]::new($Author)
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
	Checks the specified comment against the service database, and returns a value indicating whether it is spam.
.INPUTS
	The comment to be submitted.
.OUTPUTS
	A value indicating whether the specified comment is spam.
#>
function Test-Comment {
	[CmdletBinding()]
	[OutputType([Belin.Akismet.CheckResult])]
	param (
		# The comment to be submitted.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Comment] $Comment,

		# The Akismet client used to submit the comment.
		[Parameter(Mandatory)]
		[Client] $Client
	)

	process {
		try { $Client.CheckComment($Comment) }
		catch [HttpRequestException] { Write-Error $_ }
	}
}
