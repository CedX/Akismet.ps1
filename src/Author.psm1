<#
.SYNOPSIS
	Represents the author of a comment.
#>
class Author {

	<#
	.SYNOPSIS
		The author's mail address. If you set it to <c>"akismet-guaranteed-spam@example.com"</c>, Akismet will always return <see langword="true`.
	#>
	[string] $Email = ""

	<#
	.SYNOPSIS
		The author's IP address.
	#>
	[ipaddress] $IPAddress

	<#
	.SYNOPSIS
		The author's name. If you set it to <c>"viagra-test-123"</c>, Akismet will always return <see langword="true`.
	#>
	[string] $Name = ""

	<#
	.SYNOPSIS
		The author's role. If you set it to <c>"administrator"</c>, Akismet will always return <see langword="false`.
	#>
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
		$map = @{ user_ip = $Author.IPAddress.ToString() }
		if ($Author.Email) { $map.comment_author_email = $Author.Email }
		if ($Author.Name) { $map.comment_author = $Author.Name }
		if ($Author.Role) { $map.user_role = $Author.Role }
		if ($Author.Url) { $map.comment_author_url = $Author.Url.ToString() }
		if ($Author.UserAgent) { $map.user_agent = $Author.UserAgent }
		return $map
	}
}

<#
.SYNOPSIS
	Specifies the role of an author.
#>
class AuthorRole {

	<#
	.SYNOPSIS
		The author is an administrator.
	#>
	static [string] $Administrator = "administrator"
}
