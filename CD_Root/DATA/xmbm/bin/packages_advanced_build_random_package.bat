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

if [%sourcesrc%]==[core-hdd0-cfw] set res=true
if ["%res%"]==["true"] (
echo - Building %sourcesrc% installer package:
echo - Compiling rco's ...
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\*."') DO (
cd "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\%%C"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile --zlib-level 1 "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\%%C\%%C.xml" "%~dp0\%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\%%C.rco"
cd "%~dp0"
if not exist "%pkgsource%\%sourcesrc%\resources-temp\%%X\%%O\XMB Manager Plus\rco" mkdir "%pkgsource%\%sourcesrc%\resources-temp\%%X\%%O\XMB Manager Plus\rco"
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\%%C" "%pkgsource%\%sourcesrc%\resources-temp\%%X\%%O\XMB Manager Plus\rco\" >NUL
)
)
)
echo - Compiling elf ...
copy "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%external%\scetool\" >NUL
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\%sourcesrc%\" >NUL
cd "%external%\scetool\" >NUL
scetool.exe --sce-type=SELF --self-add-shdrs=TRUE --self-ctrl-flags=4000000000000000000000000000000000000000000000000000000000000000 --compress-data=TRUE --skip-sections=TRUE --key-revision=01 --self-app-version=0001000000000000 --self-auth-id=1010000001000003 --self-vendor-id=01000002 --self-type=NPDRM --self-fw-version=0003004100000000 --np-license-type=FREE --np-content-id=UP0001-%id_xmbmp%_00-0000000000000000 --np-app-type=EXEC --np-real-fname=EBOOT.BIN --encrypt "EBOOT.ELF" "EBOOT.BIN"
cd "%~dp0" >NUL
del /Q "%external%\scetool\EBOOT.ELF" > NUL
move "%external%\scetool\EBOOT.BIN" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\" > NUL


echo - Converting sfx to sfo ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFX" "%pkgsource%\%sourcesrc%\" >NUL
echo - Making package ...
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\%sourcesrc%\%id_xmbmp%
echo - Finalizing ...
move "%pkgsource%\%sourcesrc%\PARAM.SFX" "%pkgsource%\%sourcesrc%\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\%sourcesrc%\%id_xmbmp%\*.SFO" >NUL
del /Q "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\*.BIN" >NUL
move  "%pkgsource%\%sourcesrc%\EBOOT.ELF" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\" >NUL
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\%sourcesrc%\resources-temp\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\%sourcesrc%\resources-temp\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\%sourcesrc%\resources-temp\%%X\%%O\XMB Manager Plus\rco\*."') DO (
del /Q "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\*.rco" >NUL
move "%pkgsource%\%sourcesrc%\resources-temp\%%X\%%O\XMB Manager Plus\rco\%%C" "%pkgsource%\%sourcesrc%\%id_xmbmp%\USRDIR\resources\%%X\%%O\XMB Manager Plus\rco\" >NUL
)
)
)
rmdir /S /Q "%pkgsource%\%sourcesrc%\resources-temp"

)
if not ["%res%"]==["true"] (
echo - Building installer package ...
%external%\aldostools\PARAM_SFO_Editor.exe %pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFX --out=%pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFO
move "%pkgsource%\%sourcesrc%\%id_xmbmp%\PARAM.SFX" "%pkgsource%\%sourcesrc%\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%-PATCH.conf %pkgsource%\%sourcesrc%\%id_xmbmp%
move "%pkgsource%\%sourcesrc%\PARAM.SFX" "%pkgsource%\%sourcesrc%\%id_xmbmp%\" >NUL
del /Q "%pkgsource%\%sourcesrc%\%id_xmbmp%\*.SFO" >NUL
)
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
