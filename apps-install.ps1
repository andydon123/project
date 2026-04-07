$token = "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"
$headers = @{
    Authorization = "token $token"
}
Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers