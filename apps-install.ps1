# --- НАСТРОЙКИ ПУТЕЙ ---
$disk = "E:\"
$softDir = "$disk\azs"
$isoPath = "$softDir\Office24.iso"
$is64 = [Environment]::Is64BitOperatingSystem

Write-Host "--- СИСТЕМА: $($is64 ? '64-bit' : '32-bit') ---" -ForegroundColor Cyan

# 1. ИМЯ КОМПЬЮТЕРА
$newName = Read-Host "Введите имя ПК (или Enter для пропуска)"
if ($newName) {
    Write-Host "Меняю имя..."
    Rename-Computer -NewName $newName -Force -ErrorAction SilentlyContinue
}

# 2. OFFICE ИЗ ISO
if (Test-Path $isoPath) {
    Write-Host "Установка Office..." -ForegroundColor Blue
    $mount = Mount-DiskImage -ImagePath $isoPath -PassThru
    $drive = ($mount | Get-Volume).DriveLetter
    if ($drive) {
        $exe = "$($drive):\AUTORUN.exe"
        if (Test-Path $exe) { Start-Process -FilePath $exe -Wait }
        Dismount-DiskImage -ImagePath $isoPath
    }
}

# 3. УСТАНОВКА ПРОГРАММ (КОРЕНЬ И ПОДПАПКИ)
$apps = @("winrar", "pdf-xchange", "thunderbird", "totalcmd", "uninstaltool", "firebird", "sp_setup", "cz_setup", "RMS_Host")

foreach ($appName in $apps) {
    $files = Get-ChildItem -Path $softDir -Filter "$appName*" -Recurse -Include *.exe, *.msi
    if ($files) {
        $target = $null
        if ($files.Count -gt 1) {
            if ($is64) { $target = $files | Where-Object { $_.Name -match "64|x64" } | Select-Object -First 1 }
            else { $target = $files | Where-Object { $_.Name -match "32|x86" -or $_.Name -notmatch "64" } | Select-Object -First 1 }
        }
        if (!$target) { $target = $files | Select-Object -First 1 }

        Write-Host "Ставлю: $($target.Name)..." -ForegroundColor Yellow
        if ($target.Extension -eq ".msi") {
            Start-Process msiexec.exe -ArgumentList "/i `"$($target.FullName)`" /quiet" -Wait
        } else {
            Start-Process -FilePath $target.FullName -ArgumentList "/S" -Wait
        }
    }
}

# 4. AMMYY
$ammyy = Get-ChildItem -Path $softDir -Filter "ammyy.exe" -Recurse | Select-Object -First 1
if ($ammyy) {
    if (!(Test-Path "C:\Prog")) { New-Item "C:\Prog" -ItemType Directory -Force }
    Copy-Item $ammyy.FullName -Destination "C:\Prog\ammyy.exe" -Force
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut("$HOME\Desktop\Ammyy Admin.lnk")
    $s.TargetPath = "C:\Prog\ammyy.exe"; $s.Save()
}

Write-Host "ГОТОВО!" -ForegroundColor Green
pause
