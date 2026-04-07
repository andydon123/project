#Запуск объекта
$Excel = New-Object -ComObject Excel.Application
#Делаем видимым
$Excel.visible = $true
#Открываем книгу
$WorkBook = $Excel.Workbooks.Open("c:\Users\office39\Desktop\Телефонный справочник 03.09..2025.xls")
#Проверяем
$WorkBook | fl Name, Path, Author
#Переименовываем файл
#Rename-Item -Path "c:\Users\office39\Desktop\Телефонный справочник 03.09.2025.xls" -NewName "c:\Users\office39\Desktop\Телефонный справочник 03.09.2025.xls"

$limit = (Get-Date).AddMonths(-12)

Get-ChildItem -Path "C:\Users\office39\" -Recurse -File | 
    Where-Object { $_.LastWriteTime -lt $limit } | 
    Select-Object Name, 
                  Extension, 
                  @{Name="Size_MB"; Expression={[Math]::Round($_.Length / 1MB, 2)}}, 
                  LastWriteTime, 
                  DirectoryName | 
    Export-Csv -Path "C:\Users\office39\Documents\OldFiles_Final.csv" -NoTypeInformation -Encoding Unicode -Delimiter "`t"

    Move-Item -Path .\*.txt -Destination .\azs


