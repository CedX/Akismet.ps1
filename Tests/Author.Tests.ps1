using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Author` cmdlet.
#>
Describe "New-Author" {
	Context "ToHashtable" {
		It "should return only the IP address with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetAuthor -IPAddress "127.0.0.1")
			Should-BeHashtable $hashtable -Count 1
			Should-BeString "127.0.0.1" $hashtable.user_ip
		}

		It "should return a non-empty hash table with an initialized instance" {
			$author = New-AkismetAuthor `
				-IPAddress "192.168.0.1" `
				-Name "Cédric Belin" `
				-Email "contact@cedric-belin.fr" `
				-Url "https://cedric-belin.fr" `
				-UserAgent "Mozilla/5.0"

			$hashtable = [hashtable] $author
			Should-BeHashtable $hashtable -Count 5
			Should-BeString "Cédric Belin" $hashtable.comment_author -CaseSensitive
			Should-BeString "contact@cedric-belin.fr" $hashtable.comment_author_email -CaseSensitive
			Should-BeString "https://cedric-belin.fr/" $hashtable.comment_author_url -CaseSensitive
			Should-BeString "Mozilla/5.0" $hashtable.user_agent -CaseSensitive
			Should-BeString "192.168.0.1" $hashtable.user_ip
		}
	}
}
