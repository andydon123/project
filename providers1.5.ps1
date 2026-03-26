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

    # 3. Обработка парами (Объединяем 2 жирные строки в один файл)
    for ($k = 0; $k -lt $boldRows.Count; $k += 2) {
        $fileData = @()

        # --- БЛОК 1: ОСНОВНОЙ КАНАЛ ---
        $rowMain = $boldRows[$k]
        $fileData += "Основной канал"
        for ($j = 3; $j -le 10; $j++) { # Колонки C-J
            $val = $sheet.Cells.Item($rowMain, $j).Text
            $colName = $sheet.Cells.Item(1, $j).Text
            if ($val) { 
                $fileData += "    ● $colName=$val" 
            }
        }

        $fileData += "" # Разделитель между каналами

        # --- БЛОК 2: РЕЗЕРВНЫЙ КАНАЛ ---
        if (($k + 1) -lt $boldRows.Count) {
            $rowReserve = $boldRows[$k + 1]
            $fileData += "Резервный канал"
            
            # Проверка значения в колонке G (7)
            $valG = $sheet.Cells.Item($rowReserve, 7).Text.Trim().ToLower()
            
            if ($valG -eq "" -or $valG -eq "нет") {
                $fileData += "    ● Резервный канал отсутствует"
            } else {
                for ($j = 3; $j -le 10; $j++) {
                    $val = $sheet.Cells.Item($rowReserve, $j).Text
                    $colName = $sheet.Cells.Item(1, $j).Text
                    if ($val) { 
                        $fileData += "    ● $colName=$val" 
                    }
                }
            }
        } else {
            # Если пары нет (нечетное кол-во строк), просто пишем, что резерва нет
            $fileData += "Резервный канал"
            $fileData += "    ● Резервный канал отсутствует"
        }

        # 4. Сохранение файла azsXX.txt
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

Write-Host "Готово! Сформировано файлов (azs): $($fileCounter - 1)" -ForegroundColor Green

