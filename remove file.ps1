# 1. Получаем файлы в папке
Get-ChildItem -Path "c:\Users\office39\Downloads\text\BACKUP\backup\test\" -File | 
    # 2. Оставляем только те, что изменены более 30 дней назад
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-10) } | 
    # 3. Удаляем их (добавьте -WhatIf для безопасной проверки)
    Remove-Item -WhatIf("Хочу удалить файл: $_.Name")
