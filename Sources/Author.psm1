<#
.SYNOPSIS
	Represents the author of a comment.
#>
[NoRunspaceAffinity()]
class Author {

	<#
	.SYNOPSIS
		The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `$true`.
	#>
	[ValidateNotNull()]
	[string] $Email = ""

	<#
	.SYNOPSIS
		The author's IP address.
	#>
	[ValidateNotNull()]
	[ipaddress] $IPAddress

	<#
	.SYNOPSIS
		The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `$true`.
	#>
	[ValidateNotNull()]
	[string] $Name = ""

	<#
	.SYNOPSIS
		The author's role. If you set it to `"administrator"`, Akismet will always return `$false`.
	#>
	[ValidateNotNull()]
	[string] $Role = ""

	<#
	.SYNOPSIS
		The URL of the author's website.
	#>
	[uri] $Url

	<#
	.SYNOPSIS
		The author's user agent, that is the string identifying the Web browser used to submit comments.
	#>
	[ValidateNotNull()]
	[string] $UserAgent = ""

	<#
	.SYNOPSIS
		Creates a new author.
	.PARAMETER IPAddress
		The author's IP address.
	#>
	Author([ipaddress] $IPAddress) {
		$this.IPAddress = $IPAddress
	}

	<#
	.SYNOPSIS
		Converts the specified author to a hash table.
	.PARAMETER Author
		The author to convert.
	.OUTPUTS
		The hash table corresponding to the specified author.
	#>
	static [hashtable] op_Explicit([Author] $Author) {
		$hashtable = @{ user_ip = $Author.IPAddress.ToString() }
		if ($Author.Email) { $hashtable.comment_author_email = $Author.Email }
		if ($Author.Name) { $hashtable.comment_author = $Author.Name }
		if ($Author.Role) { $hashtable.user_role = $Author.Role }
		if ($Author.Url) { $hashtable.comment_author_url = $Author.Url.ToString() }
		if ($Author.UserAgent) { $hashtable.user_agent = $Author.UserAgent }
		return $hashtable
	}
}

<#
.SYNOPSIS
	Specifies the role of an author.
#>
[NoRunspaceAffinity()]
class AuthorRole {

	<#
	.SYNOPSIS
		The author is an administrator.
	#>
	static [string] $Administrator = "administrator"
}
