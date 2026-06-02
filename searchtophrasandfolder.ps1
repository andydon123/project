Add-Type -AssemblyName System.Windows.Forms

# 1. Выбор папки
function Get-FolderName($title) {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $title
    if ($folderBrowser.ShowDialog() -eq "OK") { return $folderBrowser.SelectedPath }
    return $null
}

$path = Get-FolderName "Выберите папку с файлами ТПК ГАЗ"
if (!$path) { exit }

# 2. Данные для поиска и вставки
$targetProvider = Read-Host "Введите название провайдера (например, 23NET)"
$phoneSupport   = Read-Host "Введите телефон техподдержки"
$phoneManager   = Read-Host "Введите телефон менеджера"

# Создаем гибкий шаблон для поиска (игнорируем пробелы в названии)
$searchPattern = $targetProvider -replace " ", "\s*"

$files = Get-ChildItem -Path $path -Filter *.txt -File

foreach ($file in $files) {
    $lines = Get-Content -Path $file.FullName
    $newContent = New-Object System.Collections.Generic.List[string]
    $insideTargetBlock = $false

    foreach ($line in $lines) {
        $tempLine = $line
        
        # Проверяем, является ли строка названием нужного провайдера
        if ($tempLine -match "●\s*$searchPattern") { 
            $insideTargetBlock = $true 
        }
        
        # Если мы внутри блока этого провайдера, обновляем контакты
        if ($insideTargetBlock) {
            if ($tempLine -match "● телефон техподдержки:") {
                $tempLine = "    ● телефон техподдержки: $phoneSupport"
            }
            elseif ($tempLine -match "● телефон менеджера:") {
                $tempLine = "    ● телефон менеджера: $phoneManager"
                $insideTargetBlock = $false # Выходим из режима замены после менеджера
            }
        }
        $newContent.Add($tempLine)
    }

    try {
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Обработан: $($file.Name)" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Ошибка в файле: $($file.Name)" -ForegroundColor Red
    }
}

Write-Host "`nВсе блоки $targetProvider обновлены!" -ForegroundColor Green
pause