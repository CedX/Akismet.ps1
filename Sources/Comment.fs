namespace Belin.Akismet

open System
open System.Management.Automation
open System.Net.Http

/// Creates a new comment.
[<Cmdlet(VerbsCommon.New, "Comment"); OutputType(typeof<Comment>)>]
type NewCommentCommand() =
  inherit Cmdlet()

  /// The comment's author.
  [<Parameter(Mandatory = true)>]
  member val Author: Author | null = null with get, set

  /// The comment's content.
  [<Parameter(Position = 1); ValidateNotNull>]
  member val Content = "" with get, set

  /// The context in which this comment was posted.
  [<Parameter; ValidateNotNull>]
  member val Context: string array = [||] with get, set

  /// The UTC timestamp of the creation of the comment.
  [<Parameter>]
  member val Date = Nullable<DateTime>() with get, set

  /// The permanent location of the entry the comment is submitted to.
  [<Parameter>]
  member val Permalink: Uri | null = null with get, set

  /// The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
  [<Parameter>]
  member val PostModified = Nullable<DateTime>() with get, set

  /// A string describing why the content is being rechecked.
  [<Parameter; ValidateNotNull>]
  member val RecheckReason = "" with get, set

  /// The URL of the webpage that linked to the entry being requested.
  [<Parameter>]
  member val Referrer: Uri | null = null with get, set

  /// The comment's type.
  [<Parameter; ValidateNotNull>]
  member val Type = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = this.WriteObject (Comment (
    nonNull this.Author,
    Content = this.Content,
    Context = this.Context,
    Date = this.Date,
    Permalink = this.Permalink,
    PostModified = this.PostModified,
    RecheckReason = this.RecheckReason,
    Referrer = this.Referrer,
    Type = this.Type
  ))

/// Submits the specified comment that was incorrectly marked as spam but should not have been.
[<Cmdlet(VerbsLifecycle.Submit, "Ham"); OutputType(typeof<Void>)>]
type SubmitHamCommand() =
  inherit Cmdlet()

  /// The comment to be submitted.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Comment: Comment | null = null with get, set

  /// The Akismet client used to submit the comment.
  [<Parameter(Mandatory = true)>]
  member val Client: Client | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () =
    let client = nonNull this.Client
    try client.SubmitHam (nonNull this.Comment)
    with :? HttpRequestException as ex -> this.WriteError (ErrorRecord(ex, "Client.SubmitHam", ErrorCategory.WriteError, client))

/// Submits the specified comment that was not marked as spam but should have been.
[<Cmdlet(VerbsLifecycle.Submit, "Spam"); OutputType(typeof<Void>)>]
type SubmitSpamCommand() =
  inherit Cmdlet()

  /// The comment to be submitted.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Comment: Comment | null = null with get, set

  /// The Akismet client used to submit the comment.
  [<Parameter(Mandatory = true)>]
  member val Client: Client | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () =
    let client = nonNull this.Client
    try client.SubmitSpam (nonNull this.Comment)
    with :? HttpRequestException as ex -> this.WriteError (ErrorRecord(ex, "Client.SubmitSpam", ErrorCategory.WriteError, client))

/// Checks the specified comment against the service database, and returns a value indicating whether it is spam.
[<Cmdlet(VerbsDiagnostic.Test, "Comment"); OutputType(typeof<CheckResult>)>]
type TestCommentCommand() =
  inherit Cmdlet()

  /// The comment to be submitted.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Comment: Comment | null = null with get, set

  /// The Akismet client used to submit the comment.
  [<Parameter(Mandatory = true)>]
  member val Client: Client | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () =
    let client = nonNull this.Client
    try this.WriteObject (client.CheckComment (nonNull this.Comment))
    with :? HttpRequestException as ex -> this.WriteError (ErrorRecord(ex, "Client.CheckComment", ErrorCategory.ReadError, client))
