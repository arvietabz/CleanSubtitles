@echo off
setlocal enabledelayedexpansion

echo Cleaning .srt files...

:: Get the directory where this batch file is located
set "batchdir=%~dp0"

:: Check if patterns file exists in the same directory as the batch file
if not exist "%batchdir%patterns.txt" (
    echo Error: patterns.txt not found in the same directory as this script!
    echo Please make sure patterns.txt is placed next to this batch file.
    pause
    exit /b 1
)

:: Move up to parent directory (one level above the batch file)
set "parentdir=%batchdir%..\"

echo Scanning: %parentdir% and all subfolders for .srt files...

:: Loop through all .srt files in parent directory and all subfolders
for /R "%parentdir%" %%F in (*.srt) do (
    echo Processing: %%F
    
    :: Create a temporary cleaned file
    set "tempfile=%%~dpF%%~nF.tmp"
    
    :: Remove unwanted lines using patterns from text file
    findstr /V /G:"%batchdir%patterns.txt" "%%F" > "!tempfile!"
    
    :: Overwrite the original file with the cleaned version
    move /Y "!tempfile!" "%%F" > nul
)

echo Cleaning completed!
pause
