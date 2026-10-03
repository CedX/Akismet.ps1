namespace Belin.Akismet

open System
open System.Management.Automation
open System.Net

/// Creates a new author.
[<Cmdlet(VerbsCommon.New, "Author"); OutputType(typeof<Author>)>]
type NewAuthorCommand() =
  inherit Cmdlet()

  /// The author's IP address.
  [<Parameter(Mandatory = true)>]
  member val IPAddress: IPAddress | null = null with get, set

  /// The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `true`.
  [<Parameter(Position = 1); ValidateNotNull>]
  member val Name = "" with get, set

  /// The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `true`.
  [<Parameter; ValidateNotNull>]
  member val Email = "" with get, set

  /// The author's role. If you set it to `"administrator"`, Akismet will always return `false`.
  [<Parameter; ValidateNotNull>]
  member val Role = "" with get, set

  /// The URL of the author's website.
  [<Parameter>]
  member val Url: Uri | null = null with get, set

  /// The author's user agent, that is the string identifying the Web browser used to submit comments.
  [<Parameter; ValidateNotNull>]
  member val UserAgent = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () =
    let author = Author (nonNull this.IPAddress)
    author.Email <- this.Email
    author.Name <- this.Name
    author.Role <- this.Role
    author.Url <- this.Url
    author.UserAgent <- this.UserAgent
    this.WriteObject author
