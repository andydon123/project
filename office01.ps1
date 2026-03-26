# Настройки адресов пингом на доступ
$oldIP = "\\10.10.200.20"
$newIP = "\\10.10.200.10"
# Где искать ярлыки (Рабочий стол и Документы)
$searchPaths = "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents"
$shell = New-Object -ComObject WScript.Shell
foreach ($path in $searchPaths) {    
    if (-not (Test-Path $path)) { continue }    
    Write-Host "Сканирование папки: $path" -ForegroundColor Cyan
    Get-ChildItem -Path $path -Filter *.lnk -Recurse | ForEach-Object {        
        $lnk = $shell.CreateShortcut($_.FullName)        
        $target = $lnk.TargetPath
        # 1. Работаем ТОЛЬКО если ярлык ведет на старый IP        
        if ($target.StartsWith($oldIP)) {                        
            # Заменяем IP адрес            
            $newTarget = $target.Replace($oldIP, $newIP)                        
            # 2. Заменяем \doc1 на \doc01 (регулярное выражение ищет \doc и одну цифру)            
            # $1 — это найденная цифра, $2 — это конец строки или следующий слеш            
            $newTarget = $newTarget -replace '\\doc([1-9])($|\\)', '\doc0$1$2'
            # 3. Проверяем доступность исправленного пути            
            if (Test-Path $newTarget) {                
                $lnk.TargetPath = $newTarget                
                $lnk.Save()                
                Write-Host "УСПЕХ: $($_.Name) обновлен" -ForegroundColor Green            
            } else {                
                # Если папка не найдена (например, нет прав или папки doc0X не существует)                
                Write-Host "ОШИБКА: Путь не найден для $($_.Name). Проверьте адрес: $newTarget" -ForegroundColor Red            
            }        
        }    
    }
}
Write-Host "`nОбработка завершена." -ForegroundColor Yellow