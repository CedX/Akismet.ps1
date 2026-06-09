using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Author` cmdlet.
#>
Describe "New-Author" {
	Context "ToHashtable" {
		It "should return only the IP address with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetAuthor -IPAddress "127.0.0.1")
			$hashtable.Keys | Should -HaveCount 1
			$hashtable.user_ip | Should -Be "127.0.0.1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$author = New-AkismetAuthor `
				-IPAddress "192.168.0.1" `
				-Name "Cédric Belin" `
				-Email "contact@cedric-belin.fr" `
				-Url "https://cedric-belin.fr" `
				-UserAgent "Mozilla/5.0"

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
