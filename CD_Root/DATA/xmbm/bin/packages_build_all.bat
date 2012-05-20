@echo off
title Build All
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
if not exist %pkgsource%\themepacks goto :error_source
if not exist %pkgsource%\languagepacks goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
FOR %%A IN (hdd0-cfw hdd0-cobra hdd0-nfw) DO (
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.355"') DO (
cd "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
cd "%~dp0"
move "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\core-%%A\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.341"') DO (
cd "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
cd "%~dp0"
move "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\core-%%A\" >NUL
)
%external%\make_self\make_self_npdrm.exe "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-%%A\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\core-%%A\%id_xmbmp%
move  "%pkgsource%\core-%%A\EBOOT.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\*.355"') DO (
move "%pkgsource%\core-%%A\%%X" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\*.341"') DO (
move "%pkgsource%\core-%%A\%%X" "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\" >NUL
)
del /Q /S "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q /S "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\*.BIN" >NUL
if [%%A]==[hdd0-cfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CFW.pkg >NUL
if [%%A]==[hdd0-cobra] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_CobraFW.pkg >NUL
if [%%A]==[hdd0-nfw] rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Core_NFW.pkg >NUL
)
FOR %%A IN (usb000 usb001 usb006 hfw) DO (
cd "%pkgsource%\core-%%A"
..\%external%\zip.exe -9 -r ..\%pkgoutput%\XMB_Manager_Plus_v%working_version%_Core_%%A.zip .
cd "%~dp0"
)

for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\themepacks\%%Y\%id_xmbmp%
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+v%working_version%-THEMEPACK-%%Y.pkg >NUL
)
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\languagepacks\%%X\%id_xmbmp%
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+v%working_version%-LANGUAGEPACK-%%X.pkg >NUL
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
