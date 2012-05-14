@echo off
title Build Core
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgbaseflash% goto :error_source

:build
call "%bindir%\global_messages.bat" "BUILDING"
if exist "%pkgsource%\flash" rmdir /Q /S "%pkgsource%\flash"
if not exist "%pkgsource%\flash" mkdir "%pkgsource%\flash"
xcopy /E "%pkgbaseflash%\*.*" "%pkgsource%\flash" >NUL
FOR /F "tokens=*" %%A IN ('CD') DO FOR %%B IN (%%~A) DO SET CurDir=%%B

for /f "tokens=1,2 delims=*" %%X IN ('dir /b %pkgsource%\flash\PKGMANAGE\USRDIR\resource\*.355') DO (
cd "%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X"
"%CurDir%\%external%\rcomage\Rcomage\rcomage.exe" compile "%CurDir%\%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X\%%X.xml" "%CurDir%\%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X.rco"
cd %CurDir%
rmdir /Q /S "%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X
)
for /f "tokens=1,2 delims=*" %%X IN ('dir /b %pkgsource%\flash\PKGMANAGE\USRDIR\resource\*.341') DO (
cd "%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X"
"%CurDir%\%external%\rcomage\Rcomage\rcomage.exe" compile "%CurDir%\%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X\%%X.xml" "%CurDir%\%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X.rco"
cd %CurDir%
rmdir /Q /S "%pkgsource%\flash\PKGMANAGE\USRDIR\resource\%%X
)
%external%\%packager% package-flash.conf %pkgsource%\flash\PKGMANAGE
if exist "%pkgsource%\flash" rmdir /Q /S "%pkgsource%\flash"
rename UP0001-PKGMANAGE_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Flash.pkg
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move %bindir%\*.pkg "%pkgoutput%\"
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
