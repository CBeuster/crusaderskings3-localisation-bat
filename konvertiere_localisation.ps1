# Get the current directory where the script is executed
$basePath = Get-Location
Write-Host "Starte im Ordner: $basePath"
Write-Host ""

# Find all folders ending with \localization\english (used in Paradox mods)
$englishDirs = Get-ChildItem -Path $basePath -Directory -Recurse | Where-Object {
    $_.FullName -match "[\\/]localization[\\/]english$"
}

# If no matching folders found, display a warning
if ($englishDirs.Count -eq 0) {
    Write-Host "No localization/english folders found."
}

# Process each found english localization folder
foreach ($englishDir in $englishDirs) {
    Write-Host "Gefunden: $($englishDir.FullName)"

    # Define paths: current english folder and its sibling german folder
    $englishPath = $englishDir.FullName
    $localizationDir = Split-Path $englishPath
    $germanPath = Join-Path $localizationDir "german"

    # Create the german folder if it doesn't exist
    if (-not (Test-Path $germanPath)) {
        Write-Host "Creating german folder: $germanPath"
        New-Item -ItemType Directory -Path $germanPath | Out-Null
    } else {
        Write-Host "german folder already exists: $germanPath"
    }

    # Get all *_l_english.yml files in the english folder
    $files = Get-ChildItem -Path $englishPath -Filter "*_l_english.yml"
    if ($files.Count -eq 0) {
        Write-Host "No *_l_english.yml files found in $englishPath"
    }

    # Process each file
    foreach ($file in $files) {
        Write-Host "Processing file: $($file.Name)"

        # Define source path and new filename for german version
        $source = $file.FullName
        $newName = $file.Name -replace "_l_english.yml$", "_l_german.yml"
        $target = Join-Path $germanPath $newName

        try {
            # Read the full content of the file
            $content = Get-Content $source -Raw
            # Replace only the "l_english:" header with "l_german:"
            $content = $content -replace "l_english:", "l_german:"
            # Save the new file using UTF-8 with BOM (required by Paradox games)
            Set-Content -Path $target -Value $content -Encoding UTF8
            Write-Host "Written: $target"
        } catch {
            # Show error if something goes wrong
            Write-Host ("Error writing {0}: {1}" -f $target, $_)
        }
    }

    Write-Host ""
}

# Final message and wait for user to press Enter
Write-Host ""
Write-Host "Done. Press Enter to exit."
[void][System.Console]::ReadLine()
