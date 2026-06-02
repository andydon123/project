1..62 | ForEach-Object{
    if ($_ -lt 10) {
        New-Item -Path "C:\Users\office39\Downloads\text\azs\0$_" -ItemType Directory
    } else {
        New-Item -Path "C:\Users\office39\Downloads\text\azs\$_" -ItemType Directory
    }    
}
