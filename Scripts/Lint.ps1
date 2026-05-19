using module PSScriptAnalyzer

"Performing the static analysis of source code..."
$PSScriptRoot, "Sources", "Tests" | Invoke-ScriptAnalyzer -ExcludeRule PSUseShouldProcessForStateChangingFunctions -Recurse
Test-ModuleManifest Akismet.psd1 | Out-Null
