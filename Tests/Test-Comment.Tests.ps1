<#
.SYNOPSIS
	Tests the features of the `Test-Comment` cmdlet.
#>
Describe "Test-Comment" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return [CheckResult]::Ham for valid comment (e.g. ham)" {
		Should-Be "Ham" ($ham | Test-AkismetComment -Client $client)
	}

	It "should return [CheckResult]::Spam for invalid comment (e.g. spam)" {
		"Spam", "PervasiveSpam" | Should-ContainCollection ($spam | Test-AkismetComment -Client $client)
	}
}
