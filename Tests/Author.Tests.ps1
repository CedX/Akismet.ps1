using module ../Sources/Author.psm1

<#
.SYNOPSIS
	Tests the features of the `Author` class.
#>
Describe "Author" {
	Context "ToHashtable" {
		It "should return only the IP address with a newly created instance" {
			$hashtable = [hashtable] [Author]::new("127.0.0.1")
			$hashtable.Keys | Should -HaveCount 1
			$hashtable.user_ip | Should -Be "127.0.0.1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$author = [Author]::new("192.168.0.1")
			$author.Name = "Cédric Belin"
			$author.Email = "contact@cedric-belin.fr"
			$author.Url = "https://cedric-belin.fr"
			$author.UserAgent = "Mozilla/5.0"

			$hashtable = [hashtable] $author
			$hashtable.Keys | Should -HaveCount 5
			$hashtable.comment_author | Should -BeExactly "Cédric Belin"
			$hashtable.comment_author_email | Should -BeExactly "contact@cedric-belin.fr"
			$hashtable.comment_author_url | Should -BeExactly "https://cedric-belin.fr/"
			$hashtable.user_agent | Should -BeExactly "Mozilla/5.0"
			$hashtable.user_ip | Should -Be "192.168.0.1"
		}
	}
}
