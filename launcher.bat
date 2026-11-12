@echo off
setlocal

rem Download the newest repo files into this folder, then open index.html
set "ROOT=%~dp0"
set "TMP=%TEMP%\baba-update-%RANDOM%"
mkdir "%TMP%" 2>nul
set "ZIP=%TMP%\repo.zip"

curl.exe -L --fail "https://github.com/gamer-maker-rgb/BaBa_Is_You/archive/refs/heads/main.zip" -o "%ZIP%"
if errorlevel 1 (
  echo.
  echo Download failed. Check your internet connection and try again.
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference='Stop'; $zip='%ZIP%'; $tmp='%TMP%'; Expand-Archive -LiteralPath $zip -DestinationPath $tmp -Force; $folder = Get-ChildItem -LiteralPath $tmp -Directory | Where-Object { $_.Name -like 'BaBa_Is_You*' } | Sort-Object Name | Select-Object -First 1; if (-not $folder) { throw 'The archive did not contain the expected repo folder.' }; Get-ChildItem -LiteralPath $folder.FullName -Force | Where-Object { $_.Name -ne 'launcher.bat' } | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination '%ROOT%' -Recurse -Force }"

if errorlevel 1 (
  echo.
  echo The game could not be updated.
  pause
  exit /b 1
)

if exist "%ROOT%index.html" (
  start "" "%ROOT%index.html"
) else (
  echo.
  echo index.html was not found after update.
  pause
)

rmdir /s /q "%TMP%"
endlocal
