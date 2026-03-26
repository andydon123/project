#Изменение без проверки
$oldIP = "\\10.10.200.20"
$newIP = "\\10.10.200.10"
$userProfile = "$env:USERPROFILE"
$shell = New-Object -ComObject WScript.Shell
# Рекурсивный поиск ярлыков только в вашем профиле
Get-ChildItem -Path $userProfile -Filter *.lnk -Recurse -ErrorAction SilentlyContinue | ForEach-Object {        
    # Пропускаем ярлыки, в названии которых есть "consultant" (регистр не важен)    
    if ($_.Name -like "*consultant*") { return }
    try {        
        $lnk = $shell.CreateShortcut($_.FullName)        
        $target = $lnk.TargetPath
        # Проверяем, начинается ли путь со старого IP        
        if ($target.StartsWith($oldIP)) {                        
            # 1. Меняем IP адрес            
            $newTarget = $target.Replace($oldIP, $newIP)                        
            # 2. Меняем \doc1...9 на \doc01...09 (только для цифр 1-9)            
            $newTarget = $newTarget -replace '\\doc([1-9])($|\\)', '\doc0$1$2'
            # 3. Сохраняем изменения (без проверки доступности пути)            
            if ($target -ne $newTarget) {                
                $lnk.TargetPath = $newTarget                
                $lnk.Save()                
                Write-Host "Обновлен: $($_.Name) -> $newTarget" -ForegroundColor Green            
            }        
        }    
    } catch {        
        # Пропускаем файлы, к которым нет доступа или которые нельзя прочитать        
        Write-Warning "Не удалось обработать: $($_.FullName)"    
    }
}
Write-Host "`nГотово! Все ссылки в профиле пользователя обновлены." -ForegroundColor Yellow