# Submit Ham
This call is intended for the submission of false positives - items that were incorrectly classified as spam by Akismet.
It takes identical arguments as [comment check](CommentCheck.md) and [submit spam](SubmitSpam.md).

Remember that, as explained in the [submit spam](SubmitSpam.md) documentation, you should ensure
that any values you're passing here match up with the original and corresponding [comment check](CommentCheck.md) call.

See the [Akismet API documentation](https://akismet.com/developers/detailed-docs/submit-ham-false-positives) for more information.

```pwsh
Submit-AkismetHam -Client $client -Comment $comment
```

## Parameters

### **-Client** &lt;Client&gt;
The `Client` instance used to submit the comment.

### **-Comment** &lt;Comment&gt;
The `Comment` providing the user's message to be checked.

> [!NOTE]
> Ideally, it should be the same object as the one passed to the original [comment check](CommentCheck.md) API call.

## Return value
None.

The cmdlet throws a `HttpRequestException` error when an issue occurs.
The exception `Message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

It can also fault with a custom error message (provided by the `X-akismet-alert-msg` header).
See [Response Error Codes](https://akismet.com/developers/detailed-docs/errors) for more information.

## Example
```pwsh
using module Belin.Akismet

$author = New-AkismetAuthor -IPAddress "192.168.0.1" -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:144.0) Gecko/20100101 Firefox/144.0"
$comment = New-AkismetComment "I'm testing out the Service API." -Author $author

$client = New-AkismetClient -ApiKey "123YourAPIKey" -Blog "https://www.yourblog.com"
Submit-AkismetHam -Client $client -Comment $comment
Write-Output "The comment was successfully submitted as ham."
```
