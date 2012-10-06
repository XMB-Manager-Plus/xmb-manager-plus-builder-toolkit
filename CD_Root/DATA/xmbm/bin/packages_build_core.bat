@echo off
title Build Core
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
for /f "tokens=1,2 delims=*" %%A IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
echo - Building core %%A installer package:
echo - Compiling rco's ...
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\*."') DO (
cd "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\%%C"
"%~dp0\%external%\rcomage\rcomage\rcomage.exe" compile --zlib-level 1 "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\%%C\%%C.xml" "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\%%C.rco"
cd "%~dp0"
if not exist "%pkgsource%\%%A\resources-temp\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource" mkdir "%pkgsource%\%%A\resources-temp\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource"
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\%%C" "%pkgsource%\%%A\resources-temp\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\" >NUL
)
)
)
echo - Compiling elf ...
copy "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%external%\scetool\" >NUL
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%%A\" >NUL
cd "%external%\scetool\" >NUL
scetool.exe --sce-type=SELF --self-add-shdrs=TRUE --self-ctrl-flags=4000000000000000000000000000000000000000000000000000000000000000 --compress-data=TRUE --skip-sections=TRUE --key-revision=01 --self-app-version=0001000000000000 --self-auth-id=1010000001000003 --self-vendor-id=01000002 --self-type=NPDRM --self-fw-version=0003004000000000 --np-license-type=FREE --np-content-id=UP0001-%id_xmbmp%_00-0000000000000000 --np-app-type=EXEC --np-real-fname=EBOOT.BIN --encrypt "EBOOT.ELF" "EBOOT.BIN"
cd "%~dp0" >NUL
del /Q "%external%\scetool\EBOOT.ELF" > NUL
move "%external%\scetool\EBOOT.BIN" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\" > NUL
echo - Converting sfx to sfo ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\%%A\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\%%A\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\%%A\%id_xmbmp%\PARAM.SFX" "%pkgsource%\%%A\" >NUL
echo - Making package ...
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\%%A\%id_xmbmp%
echo - Finalizing ...
move "%pkgsource%\%%A\PARAM.SFX" "%pkgsource%\%%A\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\%%A\%id_xmbmp%\*.SFO" >NUL
del /Q "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q "%pkgsource%\%%A\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\%%A\EBOOT.ELF" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\" >NUL
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\resources-temp\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%%A\resources-temp\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%%A\resources-temp\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\*."') DO (
del /Q "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\*.rco" >NUL
move "%pkgsource%\%%A\resources-temp\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\%%C" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\dev_flash~vsh~resource\" >NUL
)
)
)
rmdir /S /Q "%pkgsource%\%%A\resources-temp"
if [%%A]==[core-hdd0-cfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW.pkg >NUL
if [%%A]==[core-hdd0-cfw-full] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW_FULL.pkg >NUL
)

FOR %%A IN (usb000 usb001 usb006 hfw) DO (
cd "%pkgsource%\core-%%A"
..\%external%\zip.exe -9 -r ..\%pkgoutput%\XMB_Manager_Plus_v%working_version%_Core_%%A.zip .
cd "%~dp0"
)
move %bindir%\*.pkg "%pkgoutput%\" >NUL
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
