$targetIP = "10.10.200.10"
# Вызов окна для ввода логина и пароля
$cred = Get-Credential -Message "Введите данные для доступа к $targetIP"
# Извлечение чистых данных из объекта
$user = $cred.UserName
$pass = $cred.GetNetworkCredential().Password
# Добавление записи в Диспетчер учетных данных Windows
cmdkey /add:$targetIP /user:$user /pass:$pass
Write-Host "`nГотово! Учетные данные для $targetIP сохранены." -ForegroundColor Green