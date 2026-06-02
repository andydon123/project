# перемещаем файлы из папки в папку с указанием одной и другой папки
Add-Type -AssemblyName System.Windows.Forms

function Get-FolderName($title) {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $title
    if ($folderBrowser.ShowDialog() -eq "OK") { return $folderBrowser.SelectedPath }
    return $null
}

# 1. Выбираем откуда и куда
$sourcePath = Get-FolderName "Выберите папку ИСТОЧНИК (откуда забираем)"
$targetPath = Get-FolderName "Выберите папку НАЗНАЧЕНИЯ (куда кладем)"

if (!$sourcePath -or !$targetPath) { Write-Host "Выбор отменен."; exit }

# 2. Получаем список файлов (можно добавить -Filter *.docx или *.txt)
$files = Get-ChildItem -Path $sourcePath -File

if ($files.Count -eq 0) {
    Write-Host "В исходной папке нет файлов для перемещения." -ForegroundColor Yellow
} else {
    foreach ($file in $files) {
        try {
            # Перемещаем файл
            Move-Item -Path $file.FullName -Destination $targetPath -Force
            Write-Host "Перемещен: $($file.Name)" -ForegroundColor Cyan
        }
        catch {
            Write-Host "Ошибка при перемещении $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host "`nГотово! Все файлы перемещены." -ForegroundColor Green
}

pause