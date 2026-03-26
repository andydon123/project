$oldIP = "\\10.10.200.20"
$newIP = "\\10.10.200.10"

# Папки для поиска (Рабочий стол и Документы)
$searchPaths = "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents"

$shell = New-Object -ComObject WScript.Shell

foreach ($path in $searchPaths) {
    if (-not (Test-Path $path)) { continue }
    
    Get-ChildItem -Path $path -Filter *.lnk -Recurse | ForEach-Object {
        $lnk = $shell.CreateShortcut($_.FullName)
        $target = $lnk.TargetPath

        # 1. Проверяем, относится ли ссылка именно к нашему старому IP
        if ($target.StartsWith($oldIP)) {
            $newTarget = $target.Replace($oldIP, $newIP)

            # 2. Проверяем, работает ли новая ссылка
            if (Test-Path $newTarget) {
                $lnk.TargetPath = $newTarget
                $lnk.Save()
                Write-Host "Обновлено: $($_.Name)" -ForegroundColor Green
            } else {
                Write-Host "ОШИБКА: Путь недоступен для $($_.Name) ($newTarget)" -ForegroundColor Red
            }
        }
        # Ссылки с другими IP (например, 10.10.200.50) скрипт просто пропустит
    }
}