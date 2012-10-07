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
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\*.') DO (
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
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\*.') DO (
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
xcopy %pkgsource%\themepacks\%themesrc%\%id_xmbmp%\USRDIR\xmbmp\IMAGES\*.* /e /y %pkgsource%\custom\%id_xmbmp%\USRDIR\xmbmp\IMAGES\ >NUL
echo - Compiling rco's ...
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\*."') DO (
cd "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\%%C"
"%~dp0\%external%\rcomage\rcomage\rcomage.exe" compile --zlib-level 1 "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\%%C\%%C.xml" "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\%%C.rco"
cd "%~dp0"
if not exist "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource" mkdir "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource"
move "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\%%C" "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\" >NUL
)
)
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\*.rco.*"') DO (
cd "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\rcomage\rcomage.exe" compile  --zlib-level 1  "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X.rco"
cd "%~dp0"
move "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\custom\" >NUL
)
rename "%pkgsource%\custom\%id_xmbmp%\USRDIR\resource\*.rco" *.
echo - Compiling elf ...
copy "%pkgsource%\custom\%id_xmbmp%\USRDIR\EBOOT.ELF" "%external%\scetool\" >NUL
move "%pkgsource%\custom\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\custom\" >NUL
cd "%external%\scetool\" >NUL
scetool.exe --sce-type=SELF --self-add-shdrs=TRUE --self-ctrl-flags=4000000000000000000000000000000000000000000000000000000000000000 --compress-data=TRUE --skip-sections=TRUE --key-revision=01 --self-app-version=0001000000000000 --self-auth-id=1010000001000003 --self-vendor-id=01000002 --self-type=NPDRM --self-fw-version=0003004000000000 --np-license-type=FREE --np-content-id=UP0001-%id_xmbmp%_00-0000000000000000 --np-app-type=EXEC --np-real-fname=EBOOT.BIN --encrypt "EBOOT.ELF" "EBOOT.BIN"
cd "%~dp0" >NUL
del /Q "%external%\scetool\EBOOT.ELF" > NUL
move "%external%\scetool\EBOOT.BIN" "%pkgsource%\custom\%id_xmbmp%\USRDIR\" > NUL
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
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\custom\apps-temp\XMB Manager Plus\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\*."') DO (
del /Q "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\*.rco" >NUL
move "%pkgsource%\custom\apps-temp\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\%%C" "%pkgsource%\custom\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\dev_flash~vsh~resource\" >NUL
)
)
)
rmdir /S /Q "%pkgsource%\custom\apps-temp"
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_v%version%_Core_CFW-%themesrc%.pkg >NUL
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
