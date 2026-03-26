# Настройки путей
$excelPath = "C:\Users\office39\Desktop\excel\providers.xlsx"
$outputFolder = "C:\Users\office39\Desktop\text"
# 1. Подготовка папки (Очистка перед запуском)
if (Test-Path $outputFolder) {
    Remove-Item -Path "$outputFolder\*.txt" -Force -ErrorAction SilentlyContinue
} else {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}
# 2. Запуск Excel
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
try {
    $wb = $excel.Workbooks.Open($excelPath)
    $sheet = $wb.Sheets.Item(1)
    $rowCount = $sheet.UsedRange.Rows.Count
    $boldRows = @()
    # 3. Поиск жирных строк в КОЛОНКЕ 3 (C)    
for ($i = 2; $i -le $rowCount; $i++) {
    $cell = $sheet.Cells.Item($i, 3) 
    # Колонка C                
    # Проверяем: ячейка не пустая И шрифт жирный (или частично жирный)        
        if ($cell.Text -ne "" -and $cell.Font.Bold -ne $false) {
            $boldRows += $i
        }
    }
    # Проверка на наличие данных    
    if ($boldRows.Count -eq 0) { 
        Write-Host "ОШИБКА: Жирные строки в колонке C не найдены!" -ForegroundColor Red
        return
    }
    $fileCounter = 1
    # 4. Обработка парами (Основной + Резервный)    
    for ($k = 0; $k -lt $boldRows.Count; $k += 2) {
        $fileData = @()
        # Данные Основного канала (из первой жирной строки пары)
        $rowMain = $boldRows[$k]
        for ($j = 3; $j -le 10; $j++) {
            # Колонки C-J
            $val = $sheet.Cells.Item($rowMain, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
            if ($val) {
                $fileData += "Основной канал | $colName=$val" 
            }
        }
    # Данные Резервного канала (из второй жирной строки пары)
    if (($k + 1) -lt $boldRows.Count) {
        $fileData += "" 
        # Пустая строка-разделитель в файле
        $rowReserve = $boldRows[$k + 1]
        for ($j = 3; $j -le 10; $j++) {
            $val = $sheet.Cells.Item($rowReserve, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
                if ($val) { 
                    $fileData += "Резервный канал | $colName=$val" 
                }
            }
        }
        # 5. Сохранение файла        
        $fileName = "azs{0:D2}.txt" -f $fileCounter
        $fullPath = Join-Path $outputFolder $fileName
        $fileData | Out-File -FilePath $fullPath -Encoding utf8
        $fileCounter++
    }
}
finally {
    # 6. Закрытие процессов
    if ($wb) { 
        $wb.Close($false) 
    }
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Get-Process excel -ErrorAction SilentlyContinue | Stop-Process -Force
}
Write-Host "Успешно! Создано файлов: $($fileCounter - 1)" -ForegroundColor Cyan