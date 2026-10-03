namespace Belin.Akismet

open System
open System.Management.Automation
open System.Text

/// Creates a new blog.
[<Cmdlet(VerbsCommon.New, "Blog"); OutputType(typeof<Blog>)>]
type NewBlogCommand() =
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
  override this.ProcessRecord () =
    let blog = Blog (nonNull this.Url)
    blog.Charset <- if this.Charset.Length > 0 then withNull (Encoding.GetEncoding this.Charset) else null
    blog.Languages <- this.Languages
    this.WriteObject blog
