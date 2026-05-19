using module ../Sources/Author.psm1
using module ../Sources/CheckResult.psm1
using module ../Sources/Client.psm1
using module ../Sources/Comment.psm1

<#
.SYNOPSIS
	Tests the features of the `Client` class.
#>
Describe "Client" {
	BeforeAll {
		# The client used to query the remote API.
		$client = [Client]::new($Env:AKISMET_API_KEY, "https://github.com/CedX/Akismet.ps1")
		$client.IsTest = $true

		# A comment with content marked as ham.
		$author = [Author]::new("192.168.0.1")
		$author.Name = "Akismet"
		$author.Role = [AuthorRole]::Administrator
		$author.Url = "https://cedric-belin.fr"
		$author.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36"

		$ham = [Comment] $author
		$ham.Content = "I'm testing out the Service API."
		$ham.Referrer = "https://www.powershellgallery.com/packages/Belin.Akismet"
		$ham.Type = [CommentType]::Comment

		# A comment with content marked as spam.
		$author = [Author]::new("127.0.0.1")
		$author.Email = "akismet-guaranteed-spam@example.com"
		$author.Name = "viagra-test-123"
		$author.UserAgent = "Spam Bot/6.6.6"

		$spam = [Comment] $author
		$spam.Content = "Spam!"
		$spam.Date = Get-Date
		$spam.Type = [CommentType]::BlogPost
	}

	Context "CheckComment" {
		It "should return `[CheckResult]::Ham` for valid comment (e.g. ham)" {
			$client.CheckComment($ham) | Should -Be ([CheckResult]::Ham)
		}

		It "should return `[CheckResult]::Spam` for invalid comment (e.g. spam)" {
			$client.CheckComment($spam) | Should -BeIn ([CheckResult]::Spam, [CheckResult]::PervasiveSpam)
		}
	}

	Context "SubmitHam" {
		It "should complete without any error" {
			{ $client.SubmitHam($ham) } | Should -Not -Throw
		}
	}

	Context "SubmitSpam" {
		It "should complete without any error" {
			{ $client.SubmitSpam($spam) } | Should -Not -Throw
		}
	}

	Context "VerifyKey" {
		It "should return `$true for a valid API key" {
			$client.VerifyKey() | Should -BeTrue
		}

		It "should return `$false for an invalid API key" {
			$newClient = [Client]::new("0123456789AB", $client.Blog)
			$newClient.IsTest = $true
			$newClient.VerifyKey() | Should -BeFalse
		}
	}
}
