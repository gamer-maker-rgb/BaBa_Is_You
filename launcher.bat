@echo off
setlocal

rem Update this folder from the GitHub repo, then open index.html
set "BABA_INSTALL_DIR=%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; $install=$env:BABA_INSTALL_DIR; $work=Join-Path $env:TEMP ('baba-update-'+[guid]::NewGuid().ToString('N')); New-Item -ItemType Directory -Path $work | Out-Null; $zip=Join-Path $work 'repo.zip'; Invoke-WebRequest -Uri 'https://github.com/gamer-maker-rgb/BaBa_Is_You/archive/refs/heads/main.zip' -OutFile $zip; Expand-Archive -LiteralPath $zip -DestinationPath $work; $source=Get-ChildItem -LiteralPath $work -Directory | Select-Object -First 1; if (-not $source) { throw 'Download failed.' }; $repoRoot=Join-Path $source.FullName 'BaBa_Is_You-main'; if (-not (Test-Path -LiteralPath $repoRoot)) { $repoRoot=$source.FullName }; Get-ChildItem -LiteralPath $repoRoot -Force | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $install -Recurse -Force }; $page=Join-Path $install 'index.html'; if (-not (Test-Path -LiteralPath $page)) { throw 'index.html not found after update.' }; Start-Process -FilePath $page; if ($work -and (Test-Path -LiteralPath $work)) { Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue }"

if errorlevel 1 (
  echo.
  echo The game could not be updated. Check your internet connection and try again.
  pause
)

endlocal
