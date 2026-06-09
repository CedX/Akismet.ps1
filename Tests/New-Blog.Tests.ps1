using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Blog` cmdlet.
#>
Describe "New-Blog" {
	Context "ToHashtable" {
		It "should return only the blog URL with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetBlog "https://github.com/CedX/Akismet.ps1")
			$hashtable.Keys | Should -HaveCount 1
			$hashtable.blog | Should -BeExactly "https://github.com/CedX/Akismet.ps1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$blog = New-AkismetBlog "https://github.com/CedX/Akismet.ps1" `
				-Charset utf-8 `
				-Languages "en", "fr"

			$hashtable = [hashtable] $blog
			$hashtable.Keys | Should -HaveCount 3
			$hashtable.blog | Should -BeExactly "https://github.com/CedX/Akismet.ps1"
			$hashtable.blog_charset | Should -BeExactly "utf-8"
			$hashtable.blog_lang | Should -BeExactly "en,fr"
		}
	}
}
