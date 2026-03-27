#Создаем папку и в ней текстовый файл, названия одинаковые
$path = "C:\path" #Путь, где будем создавать папки и файлы.
0..6 | ForEach-Object {
    $folderName = "azs0$_"
    New-Item -Path "$path" -Name "$folderName" -ItemType "Directory"
    New-Item -Path "$path\$folderName" -Name "azs0$_" -ItemType "File"
}

$workers = "Дмитрий", "Илья", "Андрей" 
"$workers" | out-file C:\Users\office39\variable\workers.txt -append
$workers = Get-Content -Path "C:\Users\office39\variable\workers.txt" -Raw -Encoding UTF8