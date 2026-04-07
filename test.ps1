$folders = Get-ChildItem -Path C:\ -Directory
foreach( $folder in $folders ) {
    "Папка: $($folder.Name) - была изменена $($folder.LastWriteTime)"
}