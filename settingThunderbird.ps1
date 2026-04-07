$ProfilePath = "C:\Users\office39\AppData\Roaming\Thunderbird\Profiles\prqrccsb.default"
$UserJs = Join-Path $ProfilePath "user.js"

# Данные Яндекса
$BookID = "YandexCardDAV"
$UserEmail = "info@yandex.ru" 
$ServerUrl = "https://carddav.yandex.ru"

$Lines = @(
    "user_pref(`"ldap_2.servers.$BookID.description`", `"Яндекс Контакты`");",
    "user_pref(`"ldap_2.servers.$BookID.dirType`", 102);",
    "user_pref(`"ldap_2.servers.$BookID.uri`", `"jscarddav://$ServerUrl` Kind=1` context=0` user=$UserEmail`");"
)

# Создаем файл user.js (перезапишет старый, если был)
$Lines | Out-File -FilePath $UserJs -Encoding ascii -Force

Write-Host "Файл настроек создан: $UserJs" -ForegroundColor Green
Write-Host "Теперь просто запустите Thunderbird." -ForegroundColor Cyan