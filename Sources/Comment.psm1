using module ./Author.psm1

<#
.SYNOPSIS
	Represents a comment submitted by an author.
#>
[NoRunspaceAffinity()]
class Comment {

	<#
	.SYNOPSIS
		The comment's author.
	#>
	[ValidateNotNull()]
	[Author] $Author

	<#
	.SYNOPSIS
		The comment's content.
	#>
	[ValidateNotNull()]
	[string] $Content = ""

	<#
	.SYNOPSIS
		The context in which this comment was posted.
	#>
	[ValidateNotNull()]
	[string[]] $Context = @()

	<#
	.SYNOPSIS
		The UTC timestamp of the creation of the comment.
	#>
	[Nullable[datetime]] $Date

	<#
	.SYNOPSIS
		The permanent location of the entry the comment is submitted to.
	#>
	[uri] $Permalink

	<#
	.SYNOPSIS
		The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
	#>
	[Nullable[datetime]] $PostModified

	<#
	.SYNOPSIS
		A string describing why the content is being rechecked.
	#>
	[ValidateNotNull()]
	[string] $RecheckReason = ""

	<#
	.SYNOPSIS
		The URL of the webpage that linked to the entry being requested.
	#>
	[uri] $Referrer

	<#
	.SYNOPSIS
		The comment's type.
	#>
	[ValidateNotNull()]
	[string] $Type = ""

	<#
	.SYNOPSIS
		Creates a new comment.
	.PARAMETER Author
		The comment's author.
	#>
	Comment([Author] $Author) {
		$this.Author = $Author
	}

	<#
	.SYNOPSIS
		Converts the specified comment to a hash table.
	.PARAMETER Comment
		The comment to convert.
	.OUTPUTS
		The hash table corresponding to the specified comment.
	#>
	static [hashtable] op_Explicit([Comment] $Comment) {
		$hashtable = [hashtable] $Comment.Author
		if ($Comment.Content) { $hashtable.comment_content = $Comment.Content }
		# TODO if ($Comment.Context) { $hashtable.comment_context = $Comment.Context -join "," }
		if ($Comment.Date) { $hashtable.comment_date_gmt = $Comment.Date.ToUniversalTime().ToString("o") }
		if ($Comment.Permalink) { $hashtable.permalink = $Comment.Permalink.ToString() }
		if ($Comment.PostModified) { $hashtable.comment_post_modified_gmt = $Comment.PostModified.ToUniversalTime().ToString("o") }
		if ($Comment.RecheckReason) { $hashtable.recheck_reason = $Comment.RecheckReason }
		if ($Comment.Referrer) { $hashtable.referrer = $Comment.Referrer.ToString() }
		if ($Comment.Type) { $hashtable.comment_type = $Comment.Type }
		return $hashtable
	}
}

<#
.SYNOPSIS
	Specifies the type of a comment.
#>
class CommentType {

	<#
	.SYNOPSIS
		A blog post.
	#>
	static [string] $BlogPost = "blog-post"

	<#
	.SYNOPSIS
		A blog comment.
	#>
	static [string] $Comment = "comment"

	<#
	.SYNOPSIS
		A contact form or feedback form submission.
	#>
	static [string] $ContactForm = "contact-form"

	<#
	.SYNOPSIS
		A top-level forum post.
	#>
	static [string] $ForumPost = "forum-post"

	<#
	.SYNOPSIS
		A message sent between just a few users.
	#>
	static [string] $Message = "message"

	<#
	.SYNOPSIS
		A reply to a top-level forum post.
	#>
	static [string] $Reply = "reply"

	<#
	.SYNOPSIS
		A new user account.
	#>
	static [string] $Signup = "signup"
}
