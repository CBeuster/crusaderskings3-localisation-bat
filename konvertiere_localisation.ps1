$basePath = Get-Location
Write-Host "Starte im Ordner: $basePath"
Write-Host ""

# Suche alle Ordner mit \localization\english am Ende
$englishDirs = Get-ChildItem -Path $basePath -Directory -Recurse | Where-Object {
    $_.FullName -match "[\\/]localization[\\/]english$"
}

if ($englishDirs.Count -eq 0) {
    Write-Host "Keine passenden localization/english-Ordner gefunden."
}

foreach ($englishDir in $englishDirs) {
    Write-Host "Gefunden: $($englishDir.FullName)"

    $englishPath = $englishDir.FullName
    $localizationDir = Split-Path $englishPath
    $germanPath = Join-Path $localizationDir "german"

    if (-not (Test-Path $germanPath)) {
        Write-Host "Erstelle german-Ordner: $germanPath"
        New-Item -ItemType Directory -Path $germanPath | Out-Null
    } else {
        Write-Host "german-Ordner existiert: $germanPath"
    }

    $files = Get-ChildItem -Path $englishPath -Filter "*_l_english.yml"
    if ($files.Count -eq 0) {
        Write-Host "Keine *_l_english.yml-Dateien in $englishPath"
    }

    foreach ($file in $files) {
        Write-Host "Verarbeite Datei: $($file.Name)"

        $source = $file.FullName
        $newName = $file.Name -replace "_l_english.yml$", "_l_german.yml"
        $target = Join-Path $germanPath $newName

        try {
            $content = Get-Content $source -Raw
            $content = $content -replace "l_english:", "l_german:"
            Set-Content -Path $target -Value $content -Encoding UTF8
            Write-Host "Geschrieben: $target"
        } catch {
            Write-Host ("Fehler beim Schreiben von {0}: {1}" -f $target, $_)
        }
    }

    Write-Host ""
}

Write-Host ""
Write-Host "Fertig. Drücke Enter zum Beenden."
[void][System.Console]::ReadLine()