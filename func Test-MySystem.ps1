function Test-MySystem {
    Get-Process | Where-Object { $_.WorkingSet64 -gt 200MB } | Select-Object Name
    
}