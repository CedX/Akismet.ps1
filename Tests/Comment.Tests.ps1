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
			$hashtable | Should-BeHashtable -Count 1
			$hashtable.user_ip | Should-BeString "127.0.0.1"
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
			$hashtable | Should-BeHashtable -Count 7
			$hashtable.comment_author | Should-BeString "Cédric Belin" -CaseSensitive
			$hashtable.comment_content | Should-BeString "A user comment." -CaseSensitive
			$hashtable.comment_date_gmt | Should-BeString "2000-01-01T00:00:00.0000000Z" -CaseSensitive
			$hashtable.comment_type | Should-BeString "blog-post" -CaseSensitive
			$hashtable.referrer | Should-BeString "https://cedric-belin.fr/" -CaseSensitive
			$hashtable.user_agent | Should-BeString "Doom/6.6.6" -CaseSensitive
			$hashtable.user_ip | Should-BeString "192.168.0.1"
		}
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-Comment` cmdlet.
#>
Describe "Test-Comment" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return [CheckResult]::Ham for valid comment (e.g. ham)" {
		$ham | Test-AkismetComment -Client $client | Should-Be "Ham"
	}

	It "should return [CheckResult]::Spam for invalid comment (e.g. spam)" {
		$result = $spam | Test-AkismetComment -Client $client
		($result -eq "Spam") -or ($result -eq "PervasiveSpam") | Should-BeTrue
	}
}
