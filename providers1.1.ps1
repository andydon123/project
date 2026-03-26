$excelPath = "C:\Users\office39\Desktop\excel\providers.xlsx"
$outputFolder = "C:\Users\office39\Desktop\text"

# 1. Очистка и подготовка папки
if (Test-Path $outputFolder) {
    Remove-Item -Path "$outputFolder\*.txt" -Force -ErrorAction SilentlyContinue
} else {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($excelPath)
    $sheet = $wb.Sheets.Item(1)
    $rowCount = $sheet.UsedRange.Rows.Count
    
    $boldRows = @()

    # 2. Ищем строки, где есть жирный шрифт (Колонка A)
    for ($i = 2; $i -le $rowCount; $i++) {
        $cellFont = $sheet.Cells.Item($i, 1).Font
        # Если жирный весь текст (True) или только часть (IsNull), считаем строку целевой
        if ($cellFont.Bold -eq $true -or $null -eq $cellFont.Bold) {
            $boldRows += $i
        }
    }

    $fileCounter = 1
    # 3. Обрабатываем пары строк
    for ($k = 0; $k -lt $boldRows.Count; $k += 2) {
        $fileData = @()
        
        # Основной канал
        $rowMain = $boldRows[$k]
        for ($j = 3; $j -le 10; $j++) { # C-J
            $val = $sheet.Cells.Item($rowMain, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
            if ($val) { $fileData += "Основной канал | $colName=$val" }
        }

        # Резервный канал
        if (($k + 1) -lt $boldRows.Count) {
            $fileData += "" # Пустая строка для разделения
            $rowReserve = $boldRows[$k + 1]
            for ($j = 3; $j -le 10; $j++) {
                $val = $sheet.Cells.Item($rowReserve, $j).Text
                $colName = $sheet.Cells.Item(1, $j).Text
                if ($val) { $fileData += "Резервный канал | $colName=$val" }
            }
        }

        # Запись файла
        if ($fileData.Count -gt 0) {
            $fileName = "azs{0:D2}.txt" -f $fileCounter
            $fileData | Out-File (Join-Path $outputFolder $fileName) -Encoding utf8
            $fileCounter++
        }
    }
}
finally {
    # 4. Гарантированное закрытие Excel
    $wb.Close($false)
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Stop-Process -Name "Excel" -ErrorAction SilentlyContinue
}

Write-Host "Готово! Создано файлов: $($fileCounter - 1)" -ForegroundColor Cyan