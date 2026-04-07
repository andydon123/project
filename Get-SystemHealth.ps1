function Get-SystemHealth {    
    # 1. Список точных имен, которые мы вычислили    
    $services = "Sense", "WaaSMedicSvc", "MdCoreSvc"        
    Write-Host "--- Проверка системных служб ---" -ForegroundColor Yellow        
    foreach ($name in $services) {        
        # Используем Try/Catch для перехвата "Cannot be queried"        
        try {            $s = Get-Service -Name $name -ErrorAction Stop            
            [PSCustomObject]@{                ServiceName = $s.Name                
                Status = $s.Status                
                Type = $s.StartType                
                Message = "Доступен"            
            }        
        }        
        catch {            
            # Если Get-Service не смог опросить службу            
            [PSCustomObject]@{                
                ServiceName = $name                
                Status = "Unknown"                
                Type = "Locked"                
                Message = "Заблокировано системой (Protected)"            
            }        
        }    
    }
}
# Запуск нашего сканера
Get-SystemHealth | Format-Table -AutoSize
