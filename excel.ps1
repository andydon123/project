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