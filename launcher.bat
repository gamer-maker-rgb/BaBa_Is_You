@echo off
setlocal

rem Downloads the latest game files, updates the local folder, then opens the game.
set "BABA_INSTALL_DIR=%~dp0BaBa_Is_You_game"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $install=$env:BABA_INSTALL_DIR; $work=Join-Path $env:TEMP ('baba-update-'+[guid]::NewGuid().ToString('N')); try { New-Item -ItemType Directory -Path $work | Out-Null; $zip=Join-Path $work 'game.zip'; $extract=Join-Path $work 'extract'; Invoke-WebRequest -Uri 'https://github.com/gamer-maker-rgb/BaBa_Is_You/archive/refs/heads/main.zip' -OutFile $zip; Expand-Archive -LiteralPath $zip -DestinationPath $extract; $source=Get-ChildItem -LiteralPath $extract -Directory | Select-Object -First 1; if ($null -eq $source -or -not (Test-Path -LiteralPath (Join-Path $source.FullName 'index.html'))) { throw 'The downloaded archive does not contain index.html.' }; $backup=$install+'.old'; if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }; if (Test-Path -LiteralPath $install) { Move-Item -LiteralPath $install -Destination $backup }; try { Move-Item -LiteralPath $source.FullName -Destination $install } catch { if (Test-Path -LiteralPath $backup) { Move-Item -LiteralPath $backup -Destination $install }; throw }; if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }; Start-Process (Join-Path $install 'index.html'); Write-Host 'Game updated and opened successfully.' } finally { if (Test-Path -LiteralPath $work) { Remove-Item -LiteralPath $work -Recurse -Force } }"
if errorlevel 1 (
  echo.
  echo The game could not be updated. Check your internet connection and try again.
  pause
)

endlocal
