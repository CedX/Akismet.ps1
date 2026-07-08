using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Blog` cmdlet.
#>
Describe "New-Blog" {
	Context "ToHashtable" {
		It "should return only the blog URL with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetBlog "https://github.com/CedX/Akismet.ps1")
			Should-BeHashtable $hashtable -Count 1
			Should-BeString "https://github.com/CedX/Akismet.ps1" $hashtable.blog -CaseSensitive
		}

		It "should return a non-empty hash table with an initialized instance" {
			$blog = New-AkismetBlog "https://github.com/CedX/Akismet.ps1" `
				-Charset utf-8 `
				-Languages "en", "fr"

			$hashtable = [hashtable] $blog
			Should-BeHashtable $hashtable -Count 3
			Should-BeString "https://github.com/CedX/Akismet.ps1" $hashtable.blog -CaseSensitive
			Should-BeString "utf-8" $hashtable.blog_charset -CaseSensitive
			Should-BeString "en,fr" $hashtable.blog_lang -CaseSensitive
		}
	}
}
