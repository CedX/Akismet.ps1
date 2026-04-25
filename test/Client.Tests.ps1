using module ../src/Author.psm1
using module ../src/CheckResult.psm1
using module ../src/Client.psm1
using module ../src/Comment.psm1

<#
.SYNOPSIS
	Tests the features of the `Client` class.
#>
Describe "Client" {
	BeforeAll {
		# The client used to query the remote API.
		$client = [Client]::new($Env:AKISMET_API_KEY, "https://github.com/cedx/akismet.ps1")
		$client.IsTest = $true

		# A comment with content marked as ham.
		$author = [Author] "192.168.0.1"
		$author.Name = "Akismet"
		$author.Role = [AuthorRole]::Administrator
		$author.Url = "https://cedric-belin.fr"
		$author.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36"

		$ham = [Comment] $author
		$ham.Content = "I'm testing out the Service API."
		$ham.Referrer = "https://www.powershellgallery.com/packages/Belin.Akismet"
		$ham.Type = [CommentType]::Comment

		# A comment with content marked as spam.
		$author = [Author] "127.0.0.1"
		$author.Email = "akismet-guaranteed-spam@example.com"
		$author.Name = "viagra-test-123"
		$author.UserAgent = "Spam Bot/6.6.6"

		$spam = [Comment] $author
		$spam.Content = "Spam!"
		$spam.Date = Get-Date
		$spam.Type = [CommentType]::BlogPost
	}

	Context "CheckComment" {
		$client.CheckComment($ham) | Should -Be [CheckResult]::Ham
		$client.CheckComment($spam) | Should -BeIn [CheckResult]::Spam, [CheckResult]::PervasiveSpam
	}

	Context "SubmitHam" {
		{ $client.SubmitHam($ham) } | Should -Not -Throw
	}

	Context "SubmitSpam" {
		{ $client.SubmitSpam($spam) } | Should -Not -Throw
	}

	Context "VerifyKey" {
		$client.VerifyKey() | Should -BeTrue

		$newClient = [Client]::new("0123456789-ABCDEF", $client.Blog)
		$newClient.IsTest = $true
		$newClient.VerifyKey() | Should -BeFalse
	}
}
