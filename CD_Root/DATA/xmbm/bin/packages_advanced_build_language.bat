@echo off
title Build Language
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
SETLOCAL ENABLEDELAYEDEXPANSION
cls
echo.
echo.
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        Û {0E}             Select the Language{04}                   Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û{08} ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ» {04}Û{\n}
%external%\cecho {08}        ÍÍ¼                                                ÈÍÍ{\n}
set counter=0
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
set /a counter += 1
%external%\cecho {0F}           !counter!. %%X {\n}
)
%external%\cecho {08}        ÍÍ»                                                ÉÍÍ{\n}
%external%\cecho {04}        Û {08}ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ {04}Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {0F}{\n}
echo.
:ask_language
set /p langnum= Choose a language: 
set counter=0
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
set /a counter += 1
if [!counter!]==[%langnum%] (
set langsrc=%%X
goto :build
)
)
goto :ask_language

:build
call "%bindir%\global_messages.bat" "BUILDING"
echo - Building language pack installer package ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\PARAM.SFX" "%pkgsource%\languagepacks\%langsrc%\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\languagepacks\%langsrc%\%id_xmbmp%
move "%pkgsource%\languagepacks\%langsrc%\PARAM.SFX" "%pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%-LANGUAGEPACK-%langsrc%.pkg >NUL
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
move %bindir%\*.pkg "%pkgoutput%" >NUL

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
