# 1. Точный поиск пути к профилю
$ThunderbirdRoot = "$env:APPDATA\Thunderbird"
$ProfilesIni = Join-Path $ThunderbirdRoot "profiles.ini"

if (-not (Test-Path $ProfilesIni)) {
    Write-Error "Файл profiles.ini не найден!"
    return
}

# Извлекаем путь, убираем лишние префиксы и исправляем слеши
$ProfileRelativePath = Get-Content $ProfilesIni | Select-String "Path=" | 
                       ForEach-Object { $_.ToString().Split('=')[1].Trim() } | 
                       Select-Object -First 1

# Собираем полный путь (Thunderbird + путь из конфига)
$FullPath = [System.IO.Path]::GetFullPath((Join-Path $ThunderbirdRoot $ProfileRelativePath))
$PrefsJs = Join-Path $FullPath "prefs.js"

Write-Host "Целевой файл: $PrefsJs" -ForegroundColor Cyan

# Проверка существования
if (-not (Test-Path $PrefsJs)) {
    Write-Error "Файл prefs.js всё еще не найден. Проверьте папку: $FullPath"
    return
}

# 2. СОЗДАНИЕ РЕЗЕРВНОЙ КОПИИ
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = "$PrefsJs.$Timestamp.bak"
Copy-Item -Path $PrefsJs -Destination $BackupFile -Force
Write-Host "Бэкап создан: $BackupFile" -ForegroundColor Gray


# 3. НАСТРОЙКИ КНИГИ (измените только эти поля)
$BookID = "YandexCardDAV"
$Description = "Яндекс Контакты"
$UserEmail = "info@yandex.ru" # Ваш логин
$ServerUrl = "https://carddav.yandex.ru"

# Строки для добавления
$LinesToAdd = @(
    "user_pref(`"ldap_2.servers.$BookID.description`", `"$Description`");",
    "user_pref(`"ldap_2.servers.$BookID.dirType`", 102);",
    "user_pref(`"ldap_2.servers.$BookID.uri`", `"jscarddav://$ServerUrl` Kind=1` context=0` user=$UserEmail`");"
)

# 4. ЗАПИСЬ
$CurrentContent = Get-Content $PrefsJs -Raw
$UpdatesCount = 0

foreach ($Line in $LinesToAdd) {
    # Проверяем, нет ли уже такой настройки по ID книги
    $SettingKey = $Line.Split(',')[0]
    if ($CurrentContent -notlike "*$SettingKey*") {
        Add-Content -Path $PrefsJs -Value $Line -Encoding ASCII
        $UpdatesCount++
    }
}

if ($UpdatesCount -gt 0) {
    Write-Host "Готово! Добавлено настроек: $UpdatesCount." -ForegroundColor Green
    Write-Host "Теперь запустите Thunderbird и используйте Пароль Приложения Яндекса." -ForegroundColor Cyan
} else {
    Write-Host "Книга уже была добавлена ранее." -ForegroundColor Yellow
}