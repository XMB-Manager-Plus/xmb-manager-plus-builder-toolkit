@echo off
title Build Themes
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
echo - Building theme pack installer packages ...
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX" "%pkgsource%\themepacks\%%Y\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\themepacks\%%Y\%id_xmbmp%
move "%pkgsource%\themepacks\%%Y\PARAM.SFX" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\themepacks\%%Y\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+v%working_version%-THEMEPACK-%%Y.pkg >NUL
)
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
move %bindir%\*.pkg "%pkgoutput%\" >NUL

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
