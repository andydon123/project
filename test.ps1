$folders = Get-ChildItem -Path C:\ -Directory
foreach( $folder in $folders ) {
    "$folder"
}