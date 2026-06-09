@{
	DefaultCommandPrefix = "Akismet"
	ModuleVersion = "1.1.0"
	PowerShellVersion = "7.6"
	RootModule = "Sources/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Prevent comment spam using the Akismet service."
	GUID = "f986768a-1709-4142-815e-ce3be0db833e"

	AliasesToExport = @()
	CmdletsToExport = @()
	RequiredAssemblies = , "Binaries/Belin.Akismet.dll"
	VariablesToExport = @()

	FunctionsToExport = @(
		"New-Author"
		"New-Blog"
		"New-Client"
		"New-Comment"
		"Submit-Ham"
		"Submit-Spam"
		"Test-ApiKey"
		"Test-Comment"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/CedX/Akismet.ps1/blob/main/License.md"
			ProjectUri = "https://github.com/CedX/Akismet.ps1"
			ReleaseNotes = "https://github.com/CedX/Akismet.ps1/releases"
			Tags = "akismet", "api", "client", "comment", "spam", "validation"
		}
	}
}
