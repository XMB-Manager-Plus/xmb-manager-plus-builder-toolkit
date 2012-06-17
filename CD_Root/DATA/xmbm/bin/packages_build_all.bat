@echo off
title Build All
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
if not exist %pkgsource%\themepacks goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
for /f "tokens=1,2 delims=*" %%A IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
echo - Building core %%A installer package:
echo - Compiling rco's ...
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\*.rco.*"') DO (
cd "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile  --zlib-level 1  "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\%%A\" >NUL
)
rename "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\*.rco" *.
echo - Compiling elf ...
%external%\make_self\make_self_npdrm.exe "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%%A\" >NUL
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
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\*.rco.*"') DO (
move "%pkgsource%\%%A\%%X" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource\" >NUL
)
if [%%A]==[core-hdd0-cfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW.pkg >NUL
if [%%A]==[core-hdd0-cfw-full] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW_FULL.pkg >NUL
if [%%A]==[core-hdd0-cobra] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CobraFW.pkg >NUL
)
FOR %%A IN (usb000 usb001 usb006 hfw) DO (
echo - Zipping core %%A manual package ...
cd "%pkgsource%\core-%%A"
..\%external%\zip.exe -9 -r ..\%pkgoutput%\XMB_Manager_Plus_v%working_version%_Core_%%A.zip .
cd "%~dp0"
)
echo - Building theme pack installer packages ...
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX" "%pkgsource%\themepacks\%%Y\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\themepacks\%%Y\%id_xmbmp%
move "%pkgsource%\themepacks\%%Y\PARAM.SFX" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\themepacks\%%Y\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%-THEMEPACK-%%Y.pkg >NUL
)
if exist %pkgsource%\languagepacks (
echo - Building language pack installer packages ...
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFX" "%pkgsource%\languagepacks\%%X\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\languagepacks\%%X\%id_xmbmp%
move "%pkgsource%\languagepacks\%%X\PARAM.SFX" "%pkgsource%\languagepacks\%%X\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\languagepacks\%%X\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%-LANGUAGEPACK-%%X.pkg >NUL
)
)

move %bindir%\*.pkg "%pkgoutput%\" >NUL

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
