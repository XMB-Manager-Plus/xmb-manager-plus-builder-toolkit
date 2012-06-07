@echo off
title Build Core
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
FOR %%A IN (hdd0-cfw hdd0-cfw-full hdd0-cobra) DO (
echo - Building core %%A installer package:
echo - Compiling rco's ...
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.rco.*"') DO (
cd "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile  --zlib-level 1  "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\core-%%A\" >NUL
)
rename "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.rco" *.
echo - Compiling elf ...
%external%\make_self\make_self_npdrm.exe "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-%%A\" >NUL
echo - Converting sfx to sfo ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\core-%%A\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\core-%%A\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\core-%%A\%id_xmbmp%\PARAM.SFX" "%pkgsource%\core-%%A\" >NUL
echo - Making package ...
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\core-%%A\%id_xmbmp%
echo - Finalizing ...
move "%pkgsource%\core-%%A\PARAM.SFX" "%pkgsource%\core-%%A\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\core-%%A\%id_xmbmp%\*.SFO" >NUL
del /Q "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\core-%%A\EBOOT.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\*.rco.*"') DO (
move "%pkgsource%\core-%%A\%%X" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\" >NUL
)
if [%%A]==[hdd0-cfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW.pkg >NUL
if [%%A]==[hdd0-cfw-full] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW_FULL.pkg >NUL
if [%%A]==[hdd0-cobra] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CobraFW.pkg >NUL
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
