<#
.SYNOPSIS
	Tests the features of the `Submit-Ham` cmdlet.
#>
Describe "Submit-Ham" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should complete without any error" {
		{ $ham | Submit-AkismetHam -Client $client -ErrorAction Stop } | Should -Not -Throw
	}
}

<#
.SYNOPSIS
	Tests the features of the `Submit-Spam` cmdlet.
#>
Describe "Submit-Spam" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should complete without any error" {
		{ $spam | Submit-AkismetSpam -Client $client -ErrorAction Stop } | Should -Not -Throw
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-ApiKey` cmdlet.
#>
Describe "Test-ApiKey" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for a valid API key" {
		$client.ApiKey | Test-AkismetApiKey -Blog $client.Blog | Should -BeTrue
	}

	It "should return `$false for an invalid API key" {
		"0123456789AB" | Test-AkismetApiKey -Blog $client.Blog | Should -BeFalse
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-Comment` cmdlet.
#>
Describe "Test-Comment" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return [CheckResult]::Ham for valid comment (e.g. ham)" {
		$ham | Test-AkismetComment -Client $client | Should -Be "Ham"
	}

	It "should return [CheckResult]::Spam for invalid comment (e.g. spam)" {
		$spam | Test-AkismetComment -Client $client | Should -BeIn "Spam", "PervasiveSpam"
	}
}
