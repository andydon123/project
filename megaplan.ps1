# 1. Параметры
$taskName = "MyDelayedAppAdmin"
$exePath = "powershell.exe"
$scriptPath = "C:\dev\megaplan.ps1"
$argument = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$delayString = "PT3M"

# 2. Действие
$action = New-ScheduledTaskAction -Execute $exePath -Argument $argument

# 3. Триггер
$trigger = New-ScheduledTaskTrigger -AtLogon
$trigger.Delay = $delayString

# 4. Универсальный способ указать группу Администраторы (через SID)
$principal = New-ScheduledTaskPrincipal -GroupId "S-1-5-32-544" -RunLevel Highest

# 5. Настройки
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# 6. Регистрация
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force