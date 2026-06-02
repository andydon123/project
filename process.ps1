# ==============================================================================
# Сценарий настройки рабочего места с USB
# ==============================================================================

# 1. ИМЯ КОМПЬЮТЕРА
$newName = Read-Host "Введите имя для этого ПК (например, OFFICE-39)"
if (![string]::IsNullOrWhiteSpace($newName)) {
    Write-Host "Устанавливаю имя: $newName..." -ForegroundColor Cyan
    Rename-Computer -NewName $newName -Force -ErrorAction SilentlyContinue
}

# Путь к вашей основной папке на флешке
$softDir = Join-Path -Path $PSScriptRoot -ChildPath "_1_tpk_soft"

# 2. MICROSOFT OFFICE 2024 (Первым в очереди)
$officePath = Join-Path -Path $softDir -ChildPath "Microsoft Office LTSC 2024 Professional Plus Standard + Visio + Project 16.0.17932.2\AUTORUN.exe"
if (Test-Path $officePath) {
    Write-Host "`n--- УСТАНОВКА OFFICE 2024 ---" -ForegroundColor Blue
    Start-Process -FilePath $officePath -Wait -Verb RunAs
}

# 3. ЦИКЛ УСТАНОВКИ ПРОГРАММ
$apps = @(
    @{ Name = "WinRAR";           File = "winrar.exe";                                     Args = "/S" },
    @{ Name = "PDF-XChange";      File = "INSTALL.cmd";                                    Args = "/verysilent" },
    @{ Name = "Thunderbird";      File = "thunderbird.exe";                                Args = "-ms" },
    @{ Name = "Total Commander";  File = "Total Commander 11.56 Extended 25.9 64-bit";     Args = "" }, # Установщик
    #@{ Name = "Uninstall Tool";   File = "uninstaltool.exe";                               Args = "/verysilent" },
    @{ Name = "FireBird";        File = "Firebird-2.5.9.27139_0_x32.exe";                  Args = "" },
    @{ Name = "Программа SP";     File = "SPFront.exe";                                    Args = "" },
    #@{ Name = "Честный Знак";    File = "cz_setup.exe";                                   Args = "" },
    #@{ Name = "RMS Host";         File = "RMS_Host.msi";                                   Args = "/quiet /norestart" }
)

Write-Host "`n--- УСТАНОВКА ДОПОЛНИТЕЛЬНОГО ПО ---" -ForegroundColor Cyan
foreach ($app in $apps) {
    $fullPath = Join-Path -Path $softDir -ChildPath $app.File
    if (Test-Path $fullPath) {
        Write-Host "Ставлю: $($app.Name)..." -ForegroundColor Yellow
        if ($app.File -like "*.msi") {
            Start-Process msiexec.exe -ArgumentList "/i `"$fullPath`" $($app.Args)" -Wait
        } else {
            Start-Process -FilePath $fullPath -ArgumentList $app.Args -Wait
        }
    }
}

# 4. СПЕЦИАЛЬНАЯ ЛОГИКА ДЛЯ AMMYY (Перемещение в C:\Prog)
$ammyySource = Join-Path -Path $softDir -ChildPath "ammyy.exe"
$targetDir = "C:\Prog"
if (Test-Path $ammyySource) {
    Write-Host "`n--- КОПИРОВАНИЕ AMMYY ADMIN ---" -ForegroundColor Cyan
    if (!(Test-Path $targetDir)) { New-Item -Path $targetDir -ItemType Directory -Force }
    Copy-Item -Path $ammyySource -Destination "$targetDir\ammyy.exe" -Force
    
    # Ярлык для Ammyy
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut("$HOME\Desktop\Ammyy Admin.lnk")
    $s.TargetPath = "$targetDir\ammyy.exe"
    $s.Save()
}

# 5. ЯРЛЫК ДЛЯ SP
$spExe = "C:\Program Files (x86)\SP_Folder\SP.exe" # Уточните путь после теста!
if (Test-Path $spExe) {
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut("$HOME\Desktop\Программа SP.lnk")
    $s.TargetPath = $spExe
    $s.Save()
}

# 6. ФИНАЛ
Write-Host "`n--- ВСЁ ГОТОВО! РЕБУТ ЧЕРЕЗ 30 СЕКУНД ---" -ForegroundColor White -BackgroundColor DarkGreen
Start-Sleep -Seconds 30
Restart-Computer -Force