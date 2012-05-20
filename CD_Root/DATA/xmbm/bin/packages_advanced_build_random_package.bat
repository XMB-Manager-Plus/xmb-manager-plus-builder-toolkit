@echo off
title Build Random Package
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
SETLOCAL ENABLEDELAYEDEXPANSION
cls
echo.
echo.
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0E}                 Select the Source{04}                 л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л{08} ЩЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЛ {04}л{\n}
%external%\cecho {08}        ЭЭМ                                                ШЭЭ{\n}
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgsource%\*.') DO (
set /a counter += 1
%external%\cecho {0F}           !counter!. %%Y {\n}
)
%external%\cecho {08}        ЭЭЛ                                                ЩЭЭ{\n}
%external%\cecho {04}        л {08}ШЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭМ {04}л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {0F}{\n}
echo.
:ask_source
set /p sourcenum= Choose a source directory: 
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgsource%\*.') DO (
set /a counter += 1
if [!counter!]==[%sourcenum%] (
set sourcesrc=%%Y
goto :name
)
)
goto :ask_source

:name
cls
echo.
echo.
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0E}           Type the Name of your .pkg{04}              л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0F}            example "reallycoolpackage"{04}            л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {0F}{\n}
echo.
:ask_name
set /p pkgname= Choose the name: 
if ["%pkgname%"]==[""] goto :ask_name

:build
call "%bindir%\global_messages.bat" "BUILDING"
if [%sourcesrc%]==[core-hdd0-cfw] (
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\*.355"') DO (
cd "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\%sourcesrc%\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\*.341"') DO (
cd "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\%sourcesrc%\" >NUL
)
%external%\make_self\make_self_npdrm.exe "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%sourcesrc%\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\%sourcesrc%\%id_xmbmp%
move  "%pkgsource%\%sourcesrc%\EBOOT.ELF" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\*.355"') DO (
move "%pkgsource%\%sourcesrc%\%%X" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\*.341"') DO (
move "%pkgsource%\%sourcesrc%\%%X" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\" >NUL
)
del /Q /S "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\*.rco" >NUL
)
if not [%sourcesrc%]==[core-hdd0-cfw] %external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\%sourcesrc%\%id_xmbmp%
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg %pkgname%.pkg >NUL
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
move "%bindir%\*.pkg" "%pkgoutput%" >NUL
goto :done

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
