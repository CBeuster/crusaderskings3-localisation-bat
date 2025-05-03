@echo off
setlocal enabledelayedexpansion

for /r %%f in (*_l_english.yml) do (
    echo Bearbeite %%f
    set "file=%%f"
    set "tmpfile=%%f.tmp"

    rem --- Dateiinhalt ändern ---
    (for /f "usebackq delims=" %%l in ("%%f") do (
        set "line=%%l"
        set "line=!line:english=german!"
        echo(!line!
    )) > "!tmpfile!"

    rem --- Alte Datei ersetzen ---
    move /y "!tmpfile!" "%%f" > nul

    rem --- Dateinamen anpassen ---
    set "filepath=%%~dpf"  & rem Pfad
    set "filename=%%~nxf" & rem Dateiname mit Erweiterung
    set "newname=!filename:_l_english.yml=_l_german.yml!"
    ren "%%f" "!newname!"
    echo Umbenannt: !filename! → !newname!
)

echo Alle Dateien verarbeitet.