using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Blog` cmdlet.
#>
Describe "New-Blog" {
	Context "ToHashtable" {
		It "should return only the blog URL with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetBlog "https://github.com/CedX/Akismet.ps1")
			$hashtable | Should-BeHashtable -Count 1
			$hashtable.blog | Should-BeString "https://github.com/CedX/Akismet.ps1" -CaseSensitive
		}

		It "should return a non-empty hash table with an initialized instance" {
			$blog = New-AkismetBlog "https://github.com/CedX/Akismet.ps1" `
				-Charset utf-8 `
				-Languages "en", "fr"

			$hashtable = [hashtable] $blog
			$hashtable | Should-BeHashtable -Count 3
			$hashtable.blog | Should-BeString "https://github.com/CedX/Akismet.ps1" -CaseSensitive
			$hashtable.blog_charset | Should-BeString "utf-8" -CaseSensitive
			$hashtable.blog_lang | Should-BeString "en,fr" -CaseSensitive
		}

		It "should throw an error if the character encoding is invalid" {
			{ New-AkismetBlog "https://github.com/CedX/Akismet.ps1" -Charset FooBar -ErrorAction Stop } | Should-Throw
		}
	}
}
