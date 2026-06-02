# преобразование .txt в .docx и перемещение файлов в Backup_TXT
$path = "C:\Users\office39\Downloads\text\Backup_TXT"
$donePath = Join-Path $path "Backup_TXT"

if (-not (Test-Path $donePath)) { New-Item -ItemType Directory -Path $donePath }

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

$files = Get-ChildItem -Path $path -Filter *.txt -File

foreach ($file in $files) {
    # Принудительно преобразуем пути в обычные строки [string]
    $txtFile = [string]$file.FullName
    $docxFile = [string](Join-Path $path ($file.BaseName + ".docx"))
    
    try {
        $doc = $word.Documents.Open($txtFile, $false, $false)
        
        # Используем SaveAs2 (современный метод) и передаем параметры напрямую
        $doc.SaveAs2($docxFile, 16) 
        $doc.Close()
        
        Move-Item -Path $txtFile -Destination $donePath -Force
        Write-Host "Готово: $($file.Name)" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Ошибка в $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

$word.Quit()
Write-Host "Завершено!" -ForegroundColor Green