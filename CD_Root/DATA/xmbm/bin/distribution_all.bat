@echo off
title Distribute All
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0-cfw\%id_xmbmp% goto :error_source
if not exist %pkgoutput%\*.pkg goto :error_packages
if not exist %dropboxdir%\Public\%id_xmbmp% goto :error_dropbox
call "%bindir%\global_messages.bat" "DISTRIBUTION"
if not exist %dropboxdir%\Public\%id_xmbmp%\CORE mkdir "%dropboxdir%\Public\%id_xmbmp%\CORE" >NUL
xcopy /E /Y "%pkgoutput%\XMB_Manager_Plus_v*_Core*.*" "%dropboxdir%\Public\%id_xmbmp%\CORE\"
if not exist %dropboxdir%\Public\%id_xmbmp%\LANGUAGEPACKS mkdir "%dropboxdir%\Public\%id_xmbmp%\LANGUAGEPACKS" >NUL
xcopy /E /Y "%pkgoutput%\*LANGUAGEPACK*.pkg" "%dropboxdir%\Public\%id_xmbmp%\LANGUAGEPACKS\"
if not exist %dropboxdir%\Public\%id_xmbmp%\THEMEPACKS mkdir "%dropboxdir%\Public\%id_xmbmp%\THEMEPACKS" >NUL
xcopy /E /Y "%pkgoutput%\*THEMEPACK*.pkg" "%dropboxdir%\Public\%id_xmbmp%\THEMEPACKS\"

:done
call "%bindir%\global_messages.bat" "DISTRIBUTION-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-NO-SOURCE"
goto :end

:error_packages
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-NO-PACKAGES"
goto :end

:error_dropbox
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-NO-DROPBOX"
goto :end

:error_distribution
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-GENERIC"
goto :end

:end
exit