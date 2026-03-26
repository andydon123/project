New-Item -Path "C:\Users\office39\Documents\TempLanes" -ItemType Directory
Pause
1..5 | ForEach-Object{
    New-Item -Path "C:\Users\office39\Documents\TempLanes\test$_.txt" -ItemType File    
}