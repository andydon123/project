$ProfilePath = "C:\Users\office39\AppData\Roaming\Thunderbird\Profiles\prqrccsb.default"
$PrefsJs = Join-Path $ProfilePath "prefs.js"

# 1. Проверяем наличие prefs.js снова (после запуска он должен был создаться)
if (-not (Test-Path $PrefsJs)) {
    Write-Error "Файл prefs.js всё еще не найден. Создаем его принудительно."
    New-Item -Path $PrefsJs -ItemType File -Force
}

# 2. Ваши данные
$BookID = "YandexCardDAV"
$UserEmail = "info@tpkgaz.ru" # УКАЖИТЕ ВАШ РЕАЛЬНЫЙ ЛОГИН
$ServerUrl = "https://carddav.yandex.ru"

# 3. Строки настроек
$Lines = @(
    "user_pref(`"ldap_2.servers.$BookID.description`", `"Яндекс Контакты`");",
    "user_pref(`"ldap_2.servers.$BookID.dirType`", 102);",
    "user_pref(`"ldap_2.servers.$BookID.uri`", `"jscarddav://$ServerUrl` Kind=1` context=0` user=$UserEmail`社区");"
)

# 4. Добавляем в конец prefs.js
Add-Content -Path $PrefsJs -Value $Lines -Encoding ASCII

Write-Host "Данные добавлены в prefs.js. Теперь запустите Thunderbird." -ForegroundColor Green


Start-Process -FilePath "C:\Program Files\CRM-ТПК\unins000.exe" -ArgumentList "/SILENT /VERYSILENT /NORESTART" -Wait
