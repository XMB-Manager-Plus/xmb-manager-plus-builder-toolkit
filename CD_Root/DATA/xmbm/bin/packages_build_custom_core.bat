@echo off
title Build Custom Core
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
cls
echo.
echo.
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        Û {0E}     Version that you want for the main core{04}       Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        Û {0F}                Example "{0A}%working_version%{0F}"{04}                     Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {0F}{\n}
echo.
set /p version= Choose a version (default %working_version%): 
if ["%version%"]==[""] set version=%working_version%
SETLOCAL ENABLEDELAYEDEXPANSION
cls
echo.
echo.
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        Û {0E}    What is the core you want?              {04}       Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û{08} ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ» {04}Û{\n}
%external%\cecho {08}        ÍÍ¼                                                ÈÍÍ{\n}
set counter=0
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
set /a counter += 1
%external%\cecho {0F}            !counter!. %%X {\n}
)
%external%\cecho {08}        ÍÍ»                                                ÉÍÍ{\n}
%external%\cecho {04}        Û {08}ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ {04}Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {0F}{\n}
echo.
:ask_core
set /p corenum= Choose a core: 
set counter=0
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
set /a counter += 1
if [!counter!]==[%corenum%] (
set coresrc=%%X
goto :themes
)
)

rem :languages
rem cls
rem echo.
rem echo.
rem %external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
rem %external%\cecho {04}        Û                                                    Û{\n}
rem %external%\cecho {04}        Û {0E}    Language that you want for the main core{04}       Û{\n}
rem %external%\cecho {04}        Û                                                    Û{\n}
rem %external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
rem %external%\cecho {04}        Û{08} ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ» {04}Û{\n}
rem %external%\cecho {08}        ÍÍ¼                                                ÈÍÍ{\n}
rem set counter=0
rem for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
rem set /a counter += 1
rem %external%\cecho {0F}            !counter!. %%X {\n}
rem )
rem %external%\cecho {08}        ÍÍ»                                                ÉÍÍ{\n}
rem %external%\cecho {04}        Û {08}ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ {04}Û{\n}
rem %external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
rem %external%\cecho {0F}{\n}
rem echo.
rem :ask_language
rem set /p langnum= Choose a language: 
rem set counter=0
rem for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
rem set /a counter += 1
rem if [!counter!]==[%langnum%] (
rem set langsrc=%%X
rem goto :themes
rem )
rem )
rem goto :ask_language

:themes
cls
echo.
echo.
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        Û {0E}     Theme that you want for the main core{04}         Û{\n}
%external%\cecho {04}        Û                                                    Û{\n}
%external%\cecho {04}        ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ{\n}
%external%\cecho {04}        Û{08} ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ» {04}Û{\n}
%external%\cecho {08}        ÈÍ¼                                                ÈÍ¼{\n}
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
set /a counter += 1
%external%\cecho {0F}           !counter!. %%Y {\n}
)
%external%\cecho {08}        ÉÍ»                                                ÉÍ»{\n}
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
echo - Building custom core installer package:
if exist "%pkgsource%\custom" rmdir /Q /S "%pkgsource%\custom"
mkdir "%pkgsource%\custom\%id_xmbmp%" >NUL
xcopy %pkgsource%\%coresrc%\%id_xmbmp%\*.* /e /y %pkgsource%\custom\%id_xmbmp%\ >NUL
rem xcopy %pkgsource%\languagepacks\%langsrc%\%id_xmbmp%\USRDIR\*.* /e /y %pkgsource%\custom\%id_xmbmp%\USRDIR\ >NUL
xcopy %pkgsource%\themepacks\%themesrc%\%id_xmbmp%\USRDIR\IMAGES\*.* /e /y %pkgsource%\custom\%id_xmbmp%\USRDIR\IMAGES\ >NUL
echo - Compiling rco's ...
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\*.rco.*"') DO (
cd "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile  --zlib-level 1  "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\custom\" >NUL
)
rename "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\*.rco" *.
echo - Compiling elf ...
%external%\make_self\make_self_npdrm.exe "%pkgsource%\custom\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\custom\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\custom\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\custom\" >NUL
echo - Converting sfx to sfo ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\custom\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\custom\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\custom\%id_xmbmp%\PARAM.SFX" "%pkgsource%\custom\" >NUL
echo - Making package ...
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\custom\%id_xmbmp%
echo - Finalizing ...
move "%pkgsource%\custom\PARAM.SFX" "%pkgsource%\custom\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\custom\%id_xmbmp%\*.SFO" >NUL
del /Q "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\*.rco.*"
del /Q "%pkgsource%\custom\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\custom\EBOOT.ELF" "%pkgsource%\custom\%id_xmbmp%\USRDIR\" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\custom\*.rco.*"') DO (
move "%pkgsource%\custom\%%X" "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\" >NUL
)
rem rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%version%_Core_CFW-%langsrc%-%themesrc%.pkg >NUL
rem rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%version%_Core_CFW-%themesrc%.pkg >NUL
if not exist "%pkgoutput%" mkdir "%pkgoutput%" >NUL
move %bindir%\*.pkg "%pkgoutput%\" >NUL
if exist "%pkgsource%\custom" rmdir /Q /S "%pkgsource%\custom" >NUL

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
