$path = "C:\Users\office39\Downloads\text\BACKUP\backup\test"
$donePath = Join-Path $path "скопировано"

# Запуск Word в фоне
$word = New-Object -ComObject Word.Application
$word.Visible = $false

Get-ChildItem -Path $path -Filter *.txt | ForEach-Object {
    $txtFile = $_.FullName
    $docxFile = $txtFile -replace "\.txt$", ".docx"
    
    # 1. Открываем текстовый файл и сохраняем как .docx
    $doc = $word.Documents.Open($txtFile)
    $doc.SaveAs([ref]$docxFile, [ref]16)
    $doc.Close()
    
    # 2. Перемещаем исходный .txt в папку "скопировано"
    Move-Item -Path $txtFile -Destination $donePath -Force
    
    Write-Host "Processed and Moved: $($_.Name)" -ForegroundColor Cyan
}

$word.Quit()
Write-Host "All tasks completed!" -ForegroundColor Green