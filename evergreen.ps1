# Ищем файл манифеста на диске C и импортируем его
$moduleFile = Get-ChildItem -Path "C:\" -Filter "Evergreen.psd1" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

if ($moduleFile) {
    Import-Module $moduleFile.FullName -Force
    Write-Host "Модуль успешно загружен из: $($moduleFile.DirectoryName)" -ForegroundColor Green
    Get-EvergreenApp -Name MicrosoftEdge | Select-Object -First 1
} else {
    Write-Host "Файл Evergreen.psd1 не найден. Проверьте, куда вы его распаковали." -ForegroundColor Red
}