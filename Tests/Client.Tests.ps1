<#
.SYNOPSIS
	Tests the features of the `Submit-Ham` cmdlet.
#>
Describe "Submit-Ham" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should complete without any error" {
		& { $ham | Submit-AkismetHam -Client $client -ErrorAction Stop } | Out-Null
	}
}

<#
.SYNOPSIS
	Tests the features of the `Submit-Spam` cmdlet.
#>
Describe "Submit-Spam" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should complete without any error" {
		& { $spam | Submit-AkismetSpam -Client $client -ErrorAction Stop } | Out-Null
	}
}

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
