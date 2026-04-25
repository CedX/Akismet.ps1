using namespace System.Text

<#
.SYNOPSIS
	Represents the front page or home URL transmitted when making requests.
#>
[NoRunspaceAffinity()]
class Blog {

	<#
	.SYNOPSIS
		The character encoding for the values included in comments.
	#>
	[Encoding] $Charset

	<#
	.SYNOPSIS
		The languages in use on the blog or site, in ISO 639-1 format.
	#>
	[ValidateNotNull()]
	[string[]] $Languages = @()

	<#
	.SYNOPSIS
		The blog or site URL.
	#>
	[ValidateNotNull()]
	[uri] $Url

	<#
	.SYNOPSIS
		Creates a new blog.
	.PARAMETER Url
		The blog or site URL.
	#>
	Blog([uri] $Url) {
		$this.Url = $Url
	}

	<#
	.SYNOPSIS
		Converts the specified blog to a hash table.
	.PARAMETER Blog
		The blog to convert.
	.OUTPUTS
		The hash table corresponding to the specified blog.
	#>
	static [hashtable] op_Explicit([Blog] $Blog) {
		$hashtable = @{ blog = $Blog.Url.ToString() }
		if ($Blog.Charset) { $hashtable.blog_charset = $Blog.Charset.WebName }
		if ($Blog.Languages) { $hashtable.blog_lang = $Blog.Languages -join "," }
		return $hashtable
	}

	<#
	.SYNOPSIS
		Creates a new blog from the specified URL.
	.PARAMETER Url
		The blog or site URL.
	.OUTPUTS
		The blog corresponding to the specified URL.
	#>
	static [Blog] op_Implicit([string] $Url) {
		return [Blog]::new($Url)
	}

	<#
	.SYNOPSIS
		Creates a new blog from the specified URL.
	.PARAMETER Url
		The blog or site URL.
	.OUTPUTS
		The blog corresponding to the specified URL.
	#>
	static [Blog] op_Implicit([Uri] $Url) {
		return [Blog]::new($Url)
	}
}
