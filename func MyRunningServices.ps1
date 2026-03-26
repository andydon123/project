function Get-MyRunningServices {
    Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object Name, DisplayName
}