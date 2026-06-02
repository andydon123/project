1..15 | ForEach-Object {
    if($_ -lt 10) {
        new-item -name 0$_ -path C:\Users\office39\Documents\test -itemtype directory
    }else {
        new-item -name $_ -path C:\Users\office39\Documents\test -itemtype directory
    }
}