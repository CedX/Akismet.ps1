<#
.SYNOPSIS
	Tests the features of the `Test-ApiKey` cmdlet.
#>
Describe "Test-ApiKey" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for a valid API key" {
		Should-BeTrue ($client.ApiKey | Test-AkismetApiKey -Blog $client.Blog)
	}

	It "should return `$false for an invalid API key" {
		Should-BeFalse ("0123456789AB" | Test-AkismetApiKey -Blog $client.Blog)
	}
}
