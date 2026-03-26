# Настройки путей
$excelPath = "C:\Users\office39\Desktop\excel\providers.xlsx"
$outputFolder = "C:\Users\office39\Desktop\text"
# 1. Подготовка папки (Создание и Очистка)
if (!(Test-Path $outputFolder)) {
	New-Item -ItemType Directory -Path $outputFolder | Out-Null
} 
else {
# Удаляем старые текстовые файлы перед новым запуском    
	Remove-Item -Path (Join-Path $outputFolder "*.txt") -ErrorAction SilentlyContinue
}
# 2. Запуск Excel
	$excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Open($excelPath)
    $sheet = $wb.Sheets.Item(1)
	$rowCount = $sheet.UsedRange.Rows.Count
    $fileCounter = 1
# 3. Сбор индексов строк с жирным шрифтом в колонке A (1)
	$boldRows = @()
	for ($i = 2; $i -le $rowCount; $i++) {
		if ($sheet.Cells.Item($i, 1).Font.Bold) {
		$boldRows += $i 
	}
}
# 4. Обработка жирных строк парами (Основной + Резервный)
for ($k = 0; $k -lt $boldRows.Count; $k += 2) {
	$fileData = @()
# Сбор данных Основного канала (первая жирная строка из пары)    
	$rowMain = $boldRows[$k]
	for ($j = 3; $j -le 10; $j++) {
# Колонки C-J        
		$val = $sheet.Cells.Item($rowMain, $j).Text
		$colName = $sheet.Cells.Item(1, $j).Text
		if ($val) { 
			$fileData += "Основной канал | $colName= $val" 
		}
	}
}
# Сбор данных Резервного канала (вторая жирная строка из пары)    
if (($k + 1) -lt $boldRows.Count) {
	$rowReserve = $boldRows[$k + 1]
	for ($j = 3; $j -le 10; $j++) {
		$val = $sheet.Cells.Item($rowReserve, $j).Text
		$colName = $sheet.Cells.Item(1, $j).Text
		if ($val) { 
			$fileData += "Резервный канал | $colName= $val" 
		} 
	}
}
# 5. Сохранение итогового файла    
if ($fileData.Count -gt 0) {
	$fileName = "azs{0:D2}.txt" -f $fileCounter
	$fullPath = Join-Path $outputFolder $fileName
	$fileData | Out-File -FilePath $fullPath -Encoding utf8
	$fileCounter++
}

# 6. Закрытие Excel и очистка памяти
$wb.Close($false)
$excel.Quit()['System.Runtime.Interopservices.Marshal']::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Host "Готово! Папка очищена, создано файлов: $($fileCounter - 1)" -ForegroundColor Green