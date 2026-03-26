# 1. Укажите путь к папке с файлами
$folderPath = "C:\Users\office39\Downloads\text"
$tel1 = "● телефон техподдержки:"
$tel2 = "● телефон менеджера:"

$textToAdd = @"
    $tel1
    $tel2
"@

# 3. Обработка файлов
Get-ChildItem -Path $folderPath -Filter *.txt | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    # Добавляем строки в конец оригинала
    $content.TrimEnd() | Set-Content -Path $_.FullName -Encoding UTF8
    Add-Content -Path $_.FullName -Value $textToAdd
    Write-Host "Обновлен: $($_.Name)" -ForegroundColor Green
    Write-Host "Готово: $($_.Name) (копия создана)" -ForegroundColor Cyan
}