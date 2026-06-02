# Перенос файлов с названием azs переименование азс 
Add-Type -AssemblyName System.Windows.Forms

function Get-FolderName($title) {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $title
    if ($folderBrowser.ShowDialog() -eq "OK") { return $folderBrowser.SelectedPath }
    return $null
}

# 1. Выбор путей
$sourcePath = Get-FolderName "Выберите папку с файлами .docx (azs01...)"
$targetPath = Get-FolderName "Выберите основную папку (где папки 01, 02...)"

if (!$sourcePath -or !$targetPath) { exit }

$missingFolders = New-Object System.Collections.Generic.List[string]
$files = Get-ChildItem -Path $sourcePath -Filter *.docx -File

foreach ($file in $files) {
    # Извлекаем цифры для поиска папки (из 'azs01' получим '01')
    $onlyDigits = $file.BaseName -replace "[^\d]", ""
    
    if ($onlyDigits -ne "") {
        $targetFolder = Join-Path $targetPath $onlyDigits
        
        if (Test-Path $targetFolder -PathType Container) {
            try {
                # 1. Меняем 'azs' на 'азс' в имени
                $russianName = $file.Name -replace "azs", "азс"
                
                # 2. Добавляем приставку 'Провайдер '
                $newName = "Провайдер " + $russianName
                
                $destinationPath = Join-Path $targetFolder $newName
                
                # Перемещаем и переименовываем
                Move-Item -Path $file.FullName -Destination $destinationPath -Force
                Write-Host "Готово: $($file.Name) -> $newName (в папку $onlyDigits)" -ForegroundColor Cyan
            }
            catch {
                Write-Host "Ошибка перемещения: $($file.Name)" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Папка $onlyDigits не найдена" -ForegroundColor Yellow
            $missingFolders.Add($file.Name)
        }
    }
    else {
        $missingFolders.Add($file.Name)
    }
}

Write-Host "`n--- Завершено ---" -ForegroundColor Green
if ($missingFolders.Count -gt 0) {
    Write-Host "Файлы без папок: $($missingFolders.Count)" -ForegroundColor Red
}

Write-Host "`nНажмите любую клавишу..."
[void][System.Console]::ReadKey()