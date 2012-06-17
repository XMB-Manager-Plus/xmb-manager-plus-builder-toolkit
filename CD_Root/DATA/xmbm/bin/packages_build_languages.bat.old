@echo off
title Build Languages
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
echo - Building language pack installer packages ...
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\languagepacks\%%X\%id_xmbmp%\PARAM.SFX" "%pkgsource%\languagepacks\%%X\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\languagepacks\%%X\%id_xmbmp%
move "%pkgsource%\languagepacks\%%X\PARAM.SFX" "%pkgsource%\languagepacks\%%X\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\languagepacks\%%X\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%-LANGUAGEPACK-%%X.pkg >NUL
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
