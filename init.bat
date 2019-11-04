@echo off 
schtasks /delete /tn autoCatch
schtasks.exe /create /tn "autoCatch" /ru SYSTEM /sc ONSTART /tr "C:\ftpMonitoring\autoCatch.bat"
pause