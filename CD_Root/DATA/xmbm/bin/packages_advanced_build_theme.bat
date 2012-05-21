@echo off
title Build Theme
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
%external%\cecho {04}        Û {0E}               Select the Theme{04}                    Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û{08} ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ» {04}Û{\n}
%external%\cecho {08}        ÍÍ¼                                                ÈÍÍ{\n}
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
set /a counter += 1
%external%\cecho {0F}             !counter!. %%Y {\n}
)
%external%\cecho {08}        ÍÍ»                                                ÉÍÍ{\n}
%external%\cecho {04}        Û {08}ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ {04}Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {0F}{\n}
echo.
:ask_theme
set /p themenum= Choose a theme: 
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
set /a counter += 1
if [!counter!]==[%themenum%] (
set themesrc=%%Y
goto :build
)
)
goto :ask_theme

:build
call "%bindir%\global_messages.bat" "BUILDING"
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\themepacks\%themesrc%\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\themepacks\%themesrc%\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\themepacks\%themesrc%\%id_xmbmp%\PARAM.SFX" "%pkgsource%\themepacks\%themesrc%\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\themepacks\%themesrc%\%id_xmbmp%
move "%pkgsource%\themepacks\%themesrc%\PARAM.SFX" "%pkgsource%\themepacks\%themesrc%\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\themepacks\%themesrc%\%id_xmbmp%\*.SFO" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+v%working_version%-THEMEPACK-%themesrc%.pkg >NUL
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
move "%bindir%\*.pkg" "%pkgoutput%" >NUL

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
