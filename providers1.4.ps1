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

    # 2. Поиск жирных строк в колонке C (3)
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

    # 3. Обработка: одна строка — один файл
    $fileCounter = 1
    $boldCounter = 1 # Для чередования названий каналов

    foreach ($rowIdx in $boldRows) {
        $fileData = @()

        # Чередуем заголовок: нечетные — Основной, четные — Резервный
        $channelTitle = if ($boldCounter % 2 -ne 0) { "Основной канал" } else { "Резервный канал" }
        $fileData += $channelTitle

        # Сбор данных из колонок C(3) - J(10)
        for ($j = 3; $j -le 10; $j++) {
            $val = $sheet.Cells.Item($rowIdx, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
            if ($val) { 
                $fileData += "    ● $colName=$val" 
            }
        }

        # 4. Сохранение файла azsXX.txt
        if ($fileData.Count -gt 1) { # Проверка, что есть данные кроме заголовка
            $fileName = "azs{0:D2}.txt" -f $fileCounter
            $fullPath = Join-Path $outputFolder $fileName
            $fileData | Out-File -FilePath $fullPath -Encoding utf8
            
            $fileCounter++
            $boldCounter++
        }
    }
}
finally {
    $wb.Close($false)
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Get-Process excel -ErrorAction SilentlyContinue | Stop-Process -Force
}

Write-Host "Готово! Создано файлов: $($fileCounter - 1)" -ForegroundColor Green

