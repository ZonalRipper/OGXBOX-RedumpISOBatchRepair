@echo off
setlocal enabledelayedexpansion

:: 1. Define the starting directory
set "startPath=%~dp0"

:: 2. Source Folder Picker
echo Selecting SOURCE folder...
set "psCmdSource=Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.SelectedPath = '%startPath%'; $f.Description = 'Select Source Folder'; if($f.ShowDialog() -eq 'OK'){ $f.SelectedPath }"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "%psCmdSource%"`) do set "srcDir=%%I"

if not defined srcDir (echo Error: No source selected & pause & exit /b)

:: 3. Output Folder Picker
echo Selecting OUTPUT folder...
set "psCmdOut=Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.SelectedPath = '%srcDir%'; $f.Description = 'Select Output Folder'; if($f.ShowDialog() -eq 'OK'){ $f.SelectedPath }"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "%psCmdOut%"`) do set "outDir=%%I"

if not defined outDir (echo Error: No output selected & pause & exit /b)

:: 4. Verify dd exists
where dd >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo ---------------------------------------------------------
    echo ERROR: 'dd' not found! 
    echo Please make sure dd.exe is in your PATH or script folder.
    echo ---------------------------------------------------------
    pause & exit /b
)

:: 5. Processing Loop
echo.
echo Starting process...
echo --------------------------------------------------

:: Using 'dir /b' to strictly handle filenames with spaces/special characters
for /f "delims=" %%F in ('dir /b /a-d "%srcDir%\*.iso"') do (
    set "filename=%%F"
    
    :: Check if filename contains "[fixed]" (case insensitive)
    echo "!filename!" | findstr /i /c:"[fixed]" >nul
    if !errorlevel! neq 0 (
        :: Update the Window Title for "Progress"
        title Processing: !filename!
        
        echo.
        echo [+] WORKING ON: "!filename!"
        echo [+] TO:         "[fixed]!filename!"
        
        :: The dd command with full quotes for safety
        dd if="%srcDir%\%%F" of="%outDir%\[fixed]%%F" skip=387 bs=1M --progress
        
        echo [+] DONE: "!filename!"
        echo --------------------------------------------------
    ) else (
        echo [-] SKIPPING: "!filename!" (Already fixed)
    )
)

title Task Complete
echo.
echo All files processed successfully.
start "" "%outDir%"
pause