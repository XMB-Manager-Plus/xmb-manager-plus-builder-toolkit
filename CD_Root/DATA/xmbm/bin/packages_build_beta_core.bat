@echo off
title Build and Distribute BETA/RC
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
%external%\cecho {04}        л {0E}    What is the core you want?              {04}       л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л{08} ЩЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЛ {04}л{\n}
%external%\cecho {08}        ЭЭМ                                                ШЭЭ{\n}
set counter=0
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
set /a counter += 1
%external%\cecho {0F}            !counter!. %%X {\n}
)
%external%\cecho {08}        ЭЭЛ                                                ЩЭЭ{\n}
%external%\cecho {04}        л {08}ШЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭМ {04}л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {0F}{\n}
echo.
:ask_core
set /p corenum= Choose a core: 
set counter=0
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
set /a counter += 1
if [!counter!]==[%corenum%] (
set coresrc=%%X
goto :version
)
)

:version
cls
echo.
echo.
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0E}  Type the version of the beta/RC Core Package  ?{04}  л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0F}                  example "{02}%working_version%{0F}"{04}                   л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {0F}{\n}
echo.
set /p version= Choose a version (default %working_version%): 
if ["%version%"]==[""] set version=%working_version%
cls
echo.
echo.
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0E} Developement suffix of the beta/RC Core Package{04}   л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        л {0F} For example: "{02}BETA3{0F}" or "{02}RC2{0F}".{04}                    л{\n}
%external%\cecho {04}        л {0F} It is recommended to use capital letters{04}          л{\n}
%external%\cecho {04}        л                                                    л{\n}
%external%\cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
%external%\cecho {0F}{\n}
echo.
:ask_suffix
set /p suffix= Choose a suffix: 
if ["%suffix%"]==[""] goto :ask_suffix
call "%bindir%\global_messages.bat" "BUILDING"
echo - Building beta %coresrc% installer package:
echo - Compiling rco's ...
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\*."') DO (
cd "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\%%C"
"%~dp0\%external%\rcomage\rcomage\rcomage.exe" compile --zlib-level 1 "%~dp0\%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\%%C\%%C.xml" "%~dp0\%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\%%C.rco"
cd "%~dp0"
if not exist "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource" mkdir "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource"
move "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\%%C" "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\" >NUL
)
)
)
echo - Compiling elf ...
copy "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%external%\scetool\" >NUL
move "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%coresrc%\" >NUL
cd "%external%\scetool\" >NUL
scetool.exe --sce-type=SELF --self-add-shdrs=TRUE --self-ctrl-flags=4000000000000000000000000000000000000000000000000000000000000000 --compress-data=TRUE --skip-sections=TRUE --key-revision=01 --self-app-version=0001000000000000 --self-auth-id=1010000001000003 --self-vendor-id=01000002 --self-type=NPDRM --self-fw-version=0003004000000000 --np-license-type=FREE --np-content-id=UP0001-%id_xmbmp%_00-0000000000000000 --np-app-type=EXEC --np-real-fname=EBOOT.BIN --encrypt "EBOOT.ELF" "EBOOT.BIN"
cd "%~dp0" >NUL
del /Q "%external%\scetool\EBOOT.ELF" > NUL
move "%external%\scetool\EBOOT.BIN" "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\" > NUL
echo - Converting sfx to sfo ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\%coresrc%\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\%coresrc%\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\%coresrc%\%id_xmbmp%\PARAM.SFX" "%pkgsource%\%coresrc%\" >NUL
echo - Making package ...
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\%coresrc%\%id_xmbmp%
echo - Finalizing ...
move "%pkgsource%\%coresrc%\PARAM.SFX" "%pkgsource%\%coresrc%\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\%coresrc%\%id_xmbmp%\*.SFO" >NUL
del /Q "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\%coresrc%\EBOOT.ELF" "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\" >NUL
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\*."') DO (
del /Q "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\*.rco" >NUL
move "%pkgsource%\%coresrc%\apps-temp\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\%%C" "%pkgsource%\%coresrc%\%id_xmbmp%\USRDIR\apps\XMB Manager Plus\%%X\%%O\PS3~dev_flash~vsh~resource\" >NUL
)
)
)
rmdir /S /Q "%pkgsource%\%coresrc%\apps-temp"
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMB_Manager_Plus_%version%_%suffix%_Core_CFW.pkg >NUL
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
