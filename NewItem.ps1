New-Item -Path "C:\Users\office39\Documents\TempLanes" -ItemType Directory
Pause
1..5 | ForEach-Object{
    New-Item -Path "C:\Users\office39\Documents\TempLanes\test$_.txt" -ItemType File    
}

# Шаблон [24] найдет любую строку, где есть двойка ИЛИ четверка
Get-ChildItem -Path "c:\Users\office39\Documents\TempLanes" | Where-Object { $_.Name -match "[24]" } | Remove-Item -WhatIf

1..7 | ForEach-Object{
    New-Item -Path "c:\Users\office39\Documents\TempLanes\azs0$_" -ItemType Directory
}
 