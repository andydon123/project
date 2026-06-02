# 1. Указываем точный путь к вашей папе
$devFolder = "C:\dev\Спасибо"
$rootFile = "$devFolder\russian_trusted_root_ca_27_02_2032.cer"
$subFile = "$devFolder\russian_trusted_sub_ca_19.07.2029.cer"

# 2. Импорт корневого сертификата в хранилище пользователя
if (Test-Path $rootFile) {
    Import-Certificate -FilePath $rootFile -CertStoreLocation Cert:\CurrentUser\Root | Out-Null
    Write-Host "Корневой сертификат $rootFile успешно добавлен текущему пользователю!" -ForegroundColor Green
} else {
    Write-Host "Ошибка: Файл $rootFile не найден в папке $devFolder" -ForegroundColor Red
}

# 3. Импорт выпускающего сертификата в хранилище пользователя
if (Test-Path $subFile) {
    Import-Certificate -FilePath $subFile -CertStoreLocation Cert:\CurrentUser\CA | Out-Null
    Write-Host "Выпускающий сертификат $subFile успешно добавлен текущему пользователю!" -ForegroundColor Green
} else {
    Write-Host "Ошибка: Файл $subFile не найден в папке $devFolder" -ForegroundColor Red
}
