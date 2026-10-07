namespace Belin.Akismet

open System
open System.Management.Automation
open System.Text

/// Creates a new blog.
[<Cmdlet(VerbsCommon.New, "Blog"); OutputType(typeof<Blog>)>]
type NewBlog() =
  inherit Cmdlet()

  /// The blog or site URL.
  [<Parameter(Mandatory = true, Position = 1)>]
  member val Url: Uri | null = null with get, set

  /// The character encoding for the values included in comments.
  [<Parameter; ValidateEncoding("The specified character encoding is unknown.")>]
  member val Charset = "" with get, set

  /// The languages in use on the blog or site, in ISO 639-1 format.
  [<Parameter; ValidateNotNull>]
  member val Languages = [||] with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = this.WriteObject (Blog (
    nonNull this.Url,
    Charset = (match this.Charset.Length with 0 -> null | _ -> Encoding.GetEncoding this.Charset),
    Languages = this.Languages
  ))
