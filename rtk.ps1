# 1. ПУТЬ К ПАПКЕ
$workDir = "C:\Users\office39\Downloads\text" 
# Спрашиваем слово для поиска
$searchTag = Read-Host "Введите слово для поиска (например, Телесети)"
# 2. НОМЕРА (которые ВСТАВИМ сразу после двоеточия)
$phoneSupport = " 8-3452-56-66-60, 8-3452-69-30-40 праздничные и не рабочие дни"
$phoneManager = " 8-922-075-50-16 Екатерина (техподдержка в будни)"
$anchor = "Резервный канал"
function Process-Block ($blockText, $blockLabel, $tag) {    
    if ($blockText -match [regex]::Escape($tag)) {        
        # Заменяем только саму метку "телефон...:", добавляя номер ПОСЛЕ неё.        
        # Старый текст в конце строки сохранится автоматически.        
        $updated = $blockText -replace "(?m)(телефон техподдержки:)", "`$1$phoneSupport"        
        $updated = $updated -replace "(?m)(телефон менеджера:)", "`$1$phoneManager"                
        if ($blockText -ne $updated) {            
            Write-Host " [+] ${blockLabel}: Данные добавлены к '$tag'" -ForegroundColor Cyan            
            return $updated        
        }    
    }    
    return $blockText
}
# ЗАПУСК
if (Test-Path $workDir) {    
    Get-ChildItem -Path $workDir -Filter "*.txt" -File | ForEach-Object {        
        $file = $_        
        $content = Get-Content $file.FullName -Raw -Encoding Default                
        
        if ($content -match [regex]::Escape($anchor)) {            
            # Делим на части, убирая возможные пустые элементы            
            $parts = $content -split [regex]::Escape($anchor), 2
            
            $newBefore = Process-Block $parts[0] "Основной блок" $searchTag            
            $newAfter = Process-Block $parts[1] "Резервный блок" $searchTag                        
            
            # Склеиваем строго: блок1 + якорь + блок2            
            $newContent = $newBefore + $anchor + $newAfter        
        } else {            
            $newContent = Process-Block $content "Весь файл" $searchTag        
        }
        if ($content -ne $newContent) {            
            # Убираем возможные тройные переносы строк, если они появились            
            $newContent = $newContent -replace "(\r?\n){3,}", "`r`n`r`n"                        
            Set-Content -Path $file.FullName -Value $newContent -Encoding Default            
            Write-Host "Файл $($file.Name): ОБНОВЛЕН`n" -ForegroundColor Green        
        } else {            
            Write-Host "Файл $($file.Name): без изменений`n" -ForegroundColor Gray        
        }    
    }
} else {    
    Write-Host "ОШИБКА: Путь не найден!" -ForegroundColor Red
}
Write-Host "Работа завершена!"
pause