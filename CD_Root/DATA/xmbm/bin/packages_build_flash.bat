@echo off
title Build Core
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\flash\%id_xmbmp_flash% goto :error_source

:build
call "%bindir%\global_messages.bat" "BUILDING"
%external%\%packager% %pkgsource%\package-flash.conf %pkgsource%\flash\%id_xmbmp_flash%
rename UP0001-%id_xmbmp_flash%_00-0000000000000000.pkg XMB_Manager_Plus_v%working_version%_Flash.pkg
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move %bindir%\*.pkg "%pkgoutput%\"
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit
