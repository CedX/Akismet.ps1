using namespace System.Text
using module ../src/Blog.psm1

<#
.SYNOPSIS
	Tests the features of the `Blog` class.
#>
Describe "Blog" {
	Context "ToHashtable" {
		It "should return only the blog URL with a newly created instance" {
			$hashtable = [hashtable] [Blog]::new("https://github.com/cedx/akismet.ps1")
			$hashtable | Should -HaveCount 1
			$hashtable.blog | Should -BeExactly "https://github.com/cedx/akismet.ps1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$blog = [Blog] "https://github.com/cedx/akismet.ps1"
			$blog.Charset = [Encoding]::UTF8
			$blog.Languages = "en", "fr"

			$hashtable = [hashtable] $blog
			$hashtable | Should -HaveCount 3
			$hashtable.blog | Should -BeExactly "https://github.com/cedx/akismet.ps1"
			$hashtable.blog_charset | Should -BeExactly "utf-8"
			$hashtable.blog_lang | Should -BeExactly "en,fr"
		}
	}
}
