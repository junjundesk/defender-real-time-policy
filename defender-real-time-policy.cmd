@echo off
setlocal

fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
    exit /b
)

set "POLICY_KEY=HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"

if /i "%~1"=="restore" goto restore

reg.exe add "%POLICY_KEY%" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "Set-MpPreference -DisableRealtimeMonitoring $true; Start-Sleep -Seconds 3; $s=Get-MpComputerStatus; $p=Get-MpPreference; Write-Host ('RealTimeProtectionEnabled: ' + $s.RealTimeProtectionEnabled); Write-Host ('DisableRealtimeMonitoring: ' + $p.DisableRealtimeMonitoring)"
goto done

:restore
reg.exe delete "%POLICY_KEY%" /v DisableRealtimeMonitoring /f >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "Set-MpPreference -DisableRealtimeMonitoring $false; Start-Sleep -Seconds 3; $s=Get-MpComputerStatus; $p=Get-MpPreference; Write-Host ('RealTimeProtectionEnabled: ' + $s.RealTimeProtectionEnabled); Write-Host ('DisableRealtimeMonitoring: ' + $p.DisableRealtimeMonitoring)"

:done
echo.
pause

