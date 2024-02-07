$uuid = "12345678-90ab-cdef-1234-567890abcdef"
$watchFilePath = Join-Path -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story" -ChildPath "$uuid`__HonourMode\HonourMode.lsv"
$processCheckInterval = 30
$lastBackupTime = $null

function Is-BG3Running {
    return (Get-Process bg3 -ErrorAction SilentlyContinue) -or (Get-Process bg3_dx11 -ErrorAction SilentlyContinue)
}

function Create-Backup {
    $sourceFolder = Join-Path -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story" -ChildPath "$uuid`__HonourMode"
    $backupFolder = Join-Path -Path "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\backup" -ChildPath $uuid
	$lastModified = (Get-Item $watchFilePath).LastWriteTime
	$timestamp = $lastModified.ToString("yyyy-MM-dd_HH-mm-ss")
	$backupFileName = "$timestamp.zip"
    $webpFileName = "$timestamp.webp"

    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder
    }

	if (-not (Test-Path -Path "$backupFolder\$backupFileName" -PathType Leaf)) {
		Compress-Archive -Path "$sourceFolder" -CompressionLevel "NoCompression" -DestinationPath "$backupFolder\$backupFileName" -Force
		Copy-Item "$sourceFolder\HonourMode.webp" -Destination "$backupFolder\$webpFileName"
		Write-Host "New save detected. Backup created: $backupFileName"
	}
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Split-Path $watchFilePath
$watcher.Filter = Split-Path $watchFilePath -Leaf
$watcher.NotifyFilter = [System.IO.NotifyFilters]'LastWrite'
$watcher.EnableRaisingEvents = $false

while ($true) {
    if (Is-BG3Running) {
        $watcher.EnableRaisingEvents = $true
        Write-Host "BG3 is running. Watching for changes in file: $watchFilePath"

        $changedEvent = Register-ObjectEvent $watcher "Changed" -Action {
            Create-Backup
        }

        while (Is-BG3Running) {
            Start-Sleep -Seconds $processCheckInterval
        }

        Unregister-Event -SourceIdentifier $changedEvent.Name
        $watcher.EnableRaisingEvents = $false
        Write-Host "BG3 has exited. Stopping save watcher."
    } else {
        Write-Host "BG3 is not running. Checking again in $processCheckInterval seconds."
        Start-Sleep -Seconds $processCheckInterval
		Clear-Host
    }
}
