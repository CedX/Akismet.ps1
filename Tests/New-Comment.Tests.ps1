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
			Should-BeHashtable $hashtable -Count 1
			Should-BeString "127.0.0.1" $hashtable.user_ip
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
			Should-BeHashtable $hashtable -Count 7
			Should-BeString "Cédric Belin" $hashtable.comment_author -CaseSensitive
			Should-BeString "A user comment." $hashtable.comment_content -CaseSensitive
			Should-BeString "2000-01-01T00:00:00.0000000Z" $hashtable.comment_date_gmt -CaseSensitive
			Should-BeString "blog-post" $hashtable.comment_type -CaseSensitive
			Should-BeString "https://cedric-belin.fr/" $hashtable.referrer -CaseSensitive
			Should-BeString "Doom/6.6.6" $hashtable.user_agent -CaseSensitive
			Should-BeString "192.168.0.1" $hashtable.user_ip
		}
	}
}
