using namespace Belin.Akismet
using namespace System.Globalization
using module ../Akismet.psd1

<#
.SYNOPSIS
	Tests the features of the `New-Comment` cmdlet.
#>
Describe "New-Comment" {
	Context "ToHashtable" {
		It "should return only the author info with a newly created instance" {
			$hashtable = [hashtable] (New-AkismetComment -Author (New-AkismetAuthor -IPAddress "127.0.0.1"))
			$hashtable.Keys | Should -HaveCount 1
			$hashtable.user_ip | Should -Be "127.0.0.1"
		}

		It "should return a non-empty hash table with an initialized instance" {
			$author = New-AkismetAuthor `
				-IPAddress "192.168.0.1" `
				-Name "Cédric Belin" `
				-UserAgent "Doom/6.6.6"

			$comment = New-AkismetComment `
				-Author $author `
				-Content "A user comment." `
				-Date ([datetime]::Parse("2000-01-01T00:00:00Z", [cultureinfo]::InvariantCulture, [DateTimeStyles]::RoundtripKind)) `
				-Referrer "https://cedric-belin.fr" `
				-Type ([CommentType]::BlogPost)

			$hashtable = [hashtable] $comment
			$hashtable.Keys | Should -HaveCount 7
			$hashtable.comment_author | Should -BeExactly "Cédric Belin"
			$hashtable.comment_content | Should -BeExactly "A user comment."
			$hashtable.comment_date_gmt | Should -BeExactly "2000-01-01T00:00:00.0000000Z"
			$hashtable.comment_type | Should -BeExactly "blog-post"
			$hashtable.referrer | Should -BeExactly "https://cedric-belin.fr/"
			$hashtable.user_agent | Should -BeExactly "Doom/6.6.6"
			$hashtable.user_ip | Should -Be "192.168.0.1"
		}
	}
}
