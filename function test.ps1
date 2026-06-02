function test {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )
    
}

$files = Get-ChildItem "C:\Users\office39\Downloads" 
