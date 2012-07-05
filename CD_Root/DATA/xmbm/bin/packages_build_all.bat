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
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\*."') DO (
cd "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile --zlib-level 1 "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C\%%C.xml" "%~dp0\%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C.rco"
cd "%~dp0"
if not exist "%pkgsource%\%%A\resources-temp\%%X\%%O\xmbmanpls\rco" mkdir "%pkgsource%\%%A\resources-temp\%%X\%%O\xmbmanpls\rco"
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C" "%pkgsource%\%%A\resources-temp\%%X\%%O\xmbmanpls\rco\" >NUL
)
)
)
echo - Compiling elf ...
copy "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%external%\scetool\" >NUL
move "%pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%%A\" >NUL
cd "%external%\scetool\" >NUL
scetool.exe --sce-type=SELF --self-add-shdrs=TRUE --self-ctrl-flags=4000000000000000000000000000000000000000000000000000000000000000 --compress-data=TRUE --skip-sections=TRUE --key-revision=00,01 --self-auth-id=1010000001000003 --self-vendor-id=01000002 --self-type=NPDRM --self-fw-version=0003004100000000 --np-license-type=FREE --np-content-id=UP0001-%id_xmbmp%_00-0000000000000000 --np-app-type=EXEC --np-real-fname=EBOOT.BIN --encrypt "EBOOT.ELF" "EBOOT.BIN"
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
del /Q "%pkgsource%\%%A\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\%%A\EBOOT.ELF" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\" >NUL
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%%A\resources-temp\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%%A\resources-temp\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%%A\resources-temp\%%X\%%O\xmbmanpls\rco\*."') DO (
del /Q "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\*.rco" >NUL
move "%pkgsource%\%%A\resources-temp\%%X\%%O\xmbmanpls\rco\%%C" "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\" >NUL
)
)
)
rmdir /S /Q "%pkgsource%\%%A\resources-temp"
if [%%A]==[core-hdd0-cfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW.pkg >NUL
if [%%A]==[core-hdd0-cfw-full] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW_FULL.pkg >NUL
)
FOR %%A IN (usb000 usb001 usb006 hfw) DO (
echo - Zipping core %%A manual package ...
cd "%pkgsource%\core-%%A"
..\%external%\zip.exe -9 -r ..\%pkgoutput%\XMB_Manager_Plus_v%working_version%_Core_%%A.zip .
cd "%~dp0"
)
echo - Building theme pack installer packages ...
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\*.') DO (
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
