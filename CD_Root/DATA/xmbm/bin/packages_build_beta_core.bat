@echo off
title Build and Distribute BETA/RC
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
cls
echo.
echo.
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0E}  Type the version of the beta/RC Core Package  ?{04}  �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0F}                  example "{02}%working_version%{0F}"{04}                   �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {0F}{\n}
echo.
set /p version= Choose a version (default %working_version%): 
if ["%version%"]==[""] set version=%working_version%
cls
echo.
echo.
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0E} Developement suffix of the beta/RC Core Package{04}   �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0F} For example: "{02}BETA3{0F}" or "{02}RC2{0F}".{04}                    �{\n}
%external%\cecho {04}        � {0F} It is recommended to use capital letters{04}          �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {0F}{\n}
echo.
:ask_suffix
set /p suffix= Choose a suffix: 
if ["%suffix%"]==[""] goto :ask_suffix
call "%bindir%\global_messages.bat" "BUILDING"
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\*.355"') DO (
cd "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X"
cd "%~dp0"
move "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\core-hdd0-cfw\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\*.341"') DO (
cd "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X"
"%~dp0\%external%\rcomage\Rcomage\rcomage.exe" compile "%~dp0\%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X\%%X.xml" "%~dp0\%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X"
cd "%~dp0"
move "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\%%X" "%pkgsource%\core-hdd0-cfw\" >NUL
)
%external%\make_self\make_self_npdrm.exe "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\EBOOT.BIN" UP0001-%id_xmbmp%_00-0000000000000000 >NUL
move "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\EBOOT.ELF" "%pkgsource%\core-hdd0-cfw\" >NUL
%external%\%packager% %pkgsource%\package-%id_xmbmp%.conf %pkgsource%\core-hdd0-cfw\%id_xmbmp%
move  "%pkgsource%\core-hdd0-cfw\EBOOT.ELF" "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-cfw\*.355"') DO (
move "%pkgsource%\core-hdd0-cfw\%%X" "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\" >NUL
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-hdd0-cfw\*.341"') DO (
move "%pkgsource%\core-hdd0-cfw\%%X" "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\" >NUL
)
del /Q /S "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\resource\*.rco.*" >NUL
del /Q /S "%pkgsource%\core-hdd0-cfw\%id_xmbmp%\USRDIR\*.BIN" >NUL
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+%version%_%suffix%_Core_CFW.pkg >NUL
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
