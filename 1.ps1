# 1. Укажите путь к папке
$folderPath = "C:\Users\office39\Downloads\text"
$tel1 = "● телефон техподдержки:"
$tel2 = "● телефон менеджера:"
# Текст, который вставляем
$newLines = "    $tel1 `r`n    $tel2 "
Get-ChildItem -Path $folderPath -Filter *.txt | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    # Проверяем наличие фразы "Резервный канал"
    if ($content -match "Резервный канал") {
        # Заменяем фразу на: наш текст + сама фраза
        $updatedContent = $content -replace "Резервный канал", ($newLines + "`r`nРезервный канал")
        Set-Content -Path $_.FullName -Value $updatedContent -Encoding UTF8
        Write-Host "Обновлен: $($_.Name)" -ForegroundColor Green
    } 
    else {
        Write-Host "Фраза не найдена в: $($_.Name)" -ForegroundColor Yellow
    }
}