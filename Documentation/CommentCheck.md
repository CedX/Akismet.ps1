# Comment Check
This is the call you will make the most. It takes a number of arguments and characteristics about the submitted content
and then returns a thumbs up or thumbs down. **Performance can drop dramatically if you choose to exclude data points.**
The more data you send Akismet about each comment, the greater the accuracy. We recommend erring on the side of including too much data.

It is important to [test Akismet](Testing.md) with a significant amount of real, live data in order to draw any conclusions on accuracy.
Akismet works by comparing content to genuine spam activity happening **right now** (and this is based on more than just the content itself),
so artificially generating spam comments is not a viable approach.

See the [Akismet API documentation](https://akismet.com/developers/detailed-docs/comment-check) for more information.

```pwsh
Test-AkismetComment -Client $client -Comment $comment
```

## Parameters

### **-Client** &lt;Client&gt;
The `[Client]` instance used to submit the comment.

### **-Comment** &lt;Comment&gt;
The `[Comment]` providing the user's message to be checked.

## Return value
A `[CheckResult]` value indicating whether the given `Comment` is `"Ham"`, `"Spam"` or `"PervasiveSpam"`.

> [!TIP]
> A comment classified as `"PervasiveSpam"` can be safely discarded.

The cmdlet throws a `HttpRequestException` error when an issue occurs.
The exception `Message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

It can also fault with a custom error message (provided by the `X-akismet-alert-msg` header).
See [Response Error Codes](https://akismet.com/developers/detailed-docs/errors) for more information.

## Example
```pwsh
using module Belin.Akismet

$author = @{
  Email = "john.doe@domain.com"
  IPAddress = "192.168.0.1"
  Name = "John Doe"
  Role = "guest"
  UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"
}

$comment = @{
  Author = New-AkismetAuthor @author
  Date = Get-Date
  Content = "A user comment."
  Referrer = "https://github.com/CedX/Akismet.ps1"
  Type = "contact-form"
}

$blog = @{
  Charset = "utf-8"
  Languages = , "fr"
  Url = "https://www.yourblog.com"
}

$client = New-AkismetClient -ApiKey "123YourAPIKey" -Blog (New-AkismetBlog @blog)
$result = Test-AkismetComment -Client $client -Comment (New-AkismetComment @comment)
Write-Output ($result -eq "Ham" ? "The comment is ham." : "The comment is spam.")
```

See the [source code](https://github.com/CedX/Akismet.ps1/tree/main/Sources/Cmdlets) for detailed information
about the `New-AkismetAuthor`, `New-AkismetBlog` and `New-AkismetComment` cmdlets, and their parameters.
