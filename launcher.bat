@echo off
setlocal

rem Update this folder from the repository's main branch, then open index.html.
set "BABA_INSTALL_DIR=%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $work=$null; try { $install=$env:BABA_INSTALL_DIR; $work=Join-Path $env:TEMP ('baba-update-'+[guid]::NewGuid().ToString('N')); New-Item -ItemType Directory -Path $work | Out-Null; $zip=Join-Path $work 'repository.zip'; Invoke-WebRequest -Uri 'https://github.com/gamer-maker-rgb/BaBa_Is_You/archive/refs/heads/main.zip' -OutFile $zip; Expand-Archive -LiteralPath $zip -DestinationPath $work; $source=Get-ChildItem -LiteralPath $work -Directory | Select-Object -First 1; if (!$source -or !(Test-Path -LiteralPath (Join-Path $source.FullName 'index.html'))) { throw 'The downloaded repository does not contain index.html.' }; Get-ChildItem -LiteralPath $source.FullName -Force | Where-Object { $_.Name -ne 'launcher.bat' } | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $install -Recurse -Force }; $page=Join-Path $install 'index.html'; if (!(Test-Path -LiteralPath $page)) { throw 'index.html was not found after updating.' }; Start-Process -FilePath $page } catch { Write-Host ('Update failed: '+$_.Exception.Message); exit 1 } finally { if ($work -and (Test-Path -LiteralPath $work)) { Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue } }"
if errorlevel 1 (
  echo.
  echo The game could not be updated. Check your internet connection and try again.
  pause
)

endlocal
