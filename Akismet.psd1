@{
	DefaultCommandPrefix = "Akismet"
	ModuleVersion = "4.0.1"
	PowerShellVersion = "7.6"
	RootModule = "Binaries/Belin.Akismet.PowerShell.dll"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Prevent comment spam using the Akismet service."
	GUID = "f986768a-1709-4142-815e-ce3be0db833e"

	AliasesToExport = @()
	FunctionsToExport = @()
	RequiredAssemblies = , "Binaries/Belin.Akismet.dll"
	VariablesToExport = @()

	CmdletsToExport = @(
		"Close-Client"
		"New-Author"
		"New-Blog"
		"New-Client"
		"New-Comment"
		"Submit-Ham"
		"Submit-Spam"
		"Test-ApiKey"
		"Test-Comment"
	)

	RequiredModules = @(
		@{ ModuleName = "Belin.FSharp"; ModuleVersion = "10.1.401" }
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
