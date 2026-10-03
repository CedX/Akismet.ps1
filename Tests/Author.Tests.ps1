using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Author` cmdlet.
#>
Describe "New-Author" {
	Context "ToHashtable" {
		It "should return only the IP address with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetAuthor -IPAddress "127.0.0.1")
			$hashtable | Should-BeHashtable -Count 1
			$hashtable.user_ip | Should-BeString "127.0.0.1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$author = New-AkismetAuthor `
				-IPAddress "192.168.0.1" `
				-Name "Cédric Belin" `
				-Email "contact@cedric-belin.fr" `
				-Url "https://cedric-belin.fr" `
				-UserAgent "Mozilla/5.0"

			$hashtable = [hashtable] $author
			$hashtable | Should-BeHashtable -Count 5
			$hashtable.comment_author | Should-BeString "Cédric Belin" -CaseSensitive
			$hashtable.comment_author_email | Should-BeString "contact@cedric-belin.fr" -CaseSensitive
			$hashtable.comment_author_url | Should-BeString "https://cedric-belin.fr/" -CaseSensitive
			$hashtable.user_agent | Should-BeString "Mozilla/5.0" -CaseSensitive
			$hashtable.user_ip | Should-BeString "192.168.0.1"
		}
	}
}
