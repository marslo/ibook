param ([switch]$wait)

# Note: this script isn't as reliable as actions taken right-clicking Docker Desktop tray icon and selecting Restart
# Can't seem to invoke that functionality or otherwise restart programmatically in same fashion that clears issues.

"Stopping containers"
docker ps -q | % { docker stop $_ }
docker ps -a -q | % { docker rm $_ }

"Starting / restarting Docker..."
$dockerSvc = "com.docker.service"

Get-Process "*Docker Desktop*" `
    | Where-Object { $_.ProcessName -ne $dockerSvc } `
    | ForEach-Object { "Stopping $($_.ProcessName)"; $_.Kill(); $_.WaitForExit(); }

Get-Service -Name $dockerSvc | Where-Object {$_.Status -eq "Started"} | Restart-Service
Get-Service -Name $dockerSvc | ForEach-Object {$_.WaitForStatus("Running", '00:00:20')}

"Starting docker..."
# Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe" -Verb RunAs
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -Verb RunAs

if ($wait) {
    $attempts = 0
    "Checking Docker status..."

    do {
        docker ps -a #| Out-Null

        if ($?) {
            break;
        }

        $attempts++
        "Docker not fully ready, waiting..."
        Start-Sleep 2
    } while ($attempts -le 10)

    "Pausing until initialized..."
    Start-Sleep 6
}

"Docker started"