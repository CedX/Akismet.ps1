namespace Belin.Akismet

open System
open System.Management.Automation
open System.Net.Http

/// Releases the resources associated with the specified client.
[<Cmdlet(VerbsCommon.Close, "Client"); OutputType(typeof<Void>)>]
type CloseClientCommand() =
  inherit Cmdlet()

  /// The Akismet client to dispose.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val InputObject: Client | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = (nonNull this.InputObject).Dispose()

/// Creates a new Akismet client.
[<Cmdlet(VerbsCommon.New, "Client"); OutputType(typeof<Client>)>]
type NewClientCommand() =
  inherit Cmdlet()

  /// The assembly version.
  static let version = SemanticVersion (typeof<NewClientCommand>.Assembly.GetName().Version)

  /// The Akismet API key.
  [<Parameter(Mandatory = true, Position = 1)>]
  member val ApiKey = "" with get, set

  /// The front page or home URL of the instance making requests.
  [<Parameter(Mandatory = true)>]
  member val Blog: Blog | null = null with get, set

  /// The user agent string to use when making requests.
  [<Parameter; ValidateNotNullOrWhiteSpace>]
  member val UserAgent = $"PowerShell/{PSVersionInfo.PSVersion} | Belin.Akismet/{version}" with get, set

  /// The base URL of the remote API endpoint.
  [<Parameter; ValidateNotNull>]
  member val Uri = Uri "https://rest.akismet.com/" with get, set

  /// Value indicating whether the client operates in test mode.
  [<Parameter>]
  member val WhatIf = SwitchParameter false with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = this.WriteObject (new Client(
    this.ApiKey,
    nonNull this.Blog,
    BaseUrl = this.Uri,
    IsTest = this.WhatIf,
    UserAgent = this.UserAgent
  ))

/// Checks the API key against the service database, and returns a value indicating whether it is valid.
[<Cmdlet(VerbsDiagnostic.Test, "ApiKey"); OutputType(typeof<bool>)>]
type TestApiKeyCommand() =
  inherit Cmdlet()

  /// The Akismet API key.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val ApiKey = "" with get, set

  /// The front page or home URL of the instance making requests.
  [<Parameter(Mandatory = true)>]
  member val Blog: Blog | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () =
    use client = new Client(this.ApiKey, nonNull this.Blog)
    try this.WriteObject (client.VerifyKey())
    with :? HttpRequestException as ex -> this.WriteError (ErrorRecord(ex, "Client.VerifyKey", ErrorCategory.ReadError, client))
