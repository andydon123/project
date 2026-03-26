# Настройки
$excelPath = "C:\Users\office39\Desktop\excel\providers.xlsx"
$outputFolder = "C:\Users\office39\Desktop\text"

# 1. Подготовка папки
if (Test-Path $outputFolder) {
    Remove-Item -Path "$outputFolder\*.txt" -Force -ErrorAction SilentlyContinue
} else {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

try {
    $wb = $excel.Workbooks.Open($excelPath)
    $sheet = $wb.Sheets.Item(1)
    $rowCount = $sheet.UsedRange.Rows.Count

    # 2. Поиск всех жирных строк в колонке C (3)
    $boldRows = @()
    for ($i = 2; $i -le $rowCount; $i++) {
        $cellC = $sheet.Cells.Item($i, 3)
        if ($cellC.Text -ne "" -and $cellC.Font.Bold -ne $false) {
            $boldRows += $i
        }
    }

    if ($boldRows.Count -eq 0) {
        Write-Host "Жирные строки в столбце C не найдены!" -ForegroundColor Red
        return
    }

    $fileCounter = 1

    # 3. Обработка парами (Основной + Резервный)
    for ($k = 0; $k -lt $boldRows.Count; $k += 2) {
        $fileData = @()

        # --- ОСНОВНОЙ КАНАЛ ---
        $rowMain = $boldRows[$k]
        $fileData += "Основной канал"
        
        for ($j = 3; $j -le 10; $j++) { # Колонки C-J
            $val = $sheet.Cells.Item($rowMain, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
            if ($val) { 
                # 4 пробела + кружочек ●
                $fileData += "    ● $colName=$val" 
            }
        }

        # --- РЕЗЕРВНЫЙ КАНАЛ ---
        if (($k + 1) -lt $boldRows.Count) {
            $fileData += "" # Разделитель
            $rowReserve = $boldRows[$k + 1]
            $fileData += "Резервный канал"
            
            for ($j = 3; $j -le 10; $j++) {
                $val = $sheet.Cells.Item($rowReserve, $j).Text
                $colName = $sheet.Cells.Item(1, $j).Text
                if ($val) { 
                    $fileData += "    ● $colName=$val" 
                }
            }
        }

        # 4. Сохранение файла (ОБЯЗАТЕЛЬНО UTF8 для поддержки кружочка)
        $fileName = "azs{0:D2}.txt" -f $fileCounter
        $fullPath = Join-Path $outputFolder $fileName
        $fileData | Out-File -FilePath $fullPath -Encoding utf8
        $fileCounter++
    }
}
finally {
    $wb.Close($false)
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Get-Process excel -ErrorAction SilentlyContinue | Stop-Process -Force
}

Write-Host "Готово! Кружочки добавлены. Файлы в: $outputFolder" -ForegroundColor Green