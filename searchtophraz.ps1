# короткий вариант
#Get-ChildItem -Path "C:\Путь\К\Папке" -Filter *.txt | Select-String -Pattern "Ваша Фраза"

# Вариант с выбором папки и вводом фразы
Add-Type -AssemblyName System.Windows.Forms

# Выбор папки
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
if ($folderBrowser.ShowDialog() -ne "OK") { exit }
$path = $folderBrowser.SelectedPath

# Запрос фразы
$phrase = Read-Host "Введите фразу для поиска"

Write-Host "`nИщем в: $path ...`n" -ForegroundColor Gray

# Поиск
$results = Get-ChildItem -Path $path -Filter *.txt -File | Select-String -Pattern $phrase

if ($results) {
    foreach ($line in $results) {
        # Вывод: ИмяФайла : НомерСтроки : ТекстСтроки
        Write-Host "$($line.FileName):$($line.LineNumber):" -NoNewline -ForegroundColor Cyan
        Write-Host " $($line.Line.Trim())"
    }
} else {
    Write-Host "Ничего не найдено." -ForegroundColor Yellow
}

Write-Host "`nПоиск завершен."
pause