@echo off
title Build Source
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
call "%bindir%\global_messages.bat" "BUILDING"
if exist "%pkgsource%" rmdir /Q /S "%pkgsource%"
if not exist "%pkgsource%" mkdir "%pkgsource%"

echo.
echo CREATING FLASH Mod source files ...
echo.
if exist "%pkgsource%\flash" rmdir /Q /S "%pkgsource%\flash"
if not exist "%pkgsource%\flash\%id_xmbmp_flash%" mkdir "%pkgsource%\flash\%id_xmbmp_flash%"
xcopy /E "%pkgbaseflash%\APPTITLID\*.*" "%pkgsource%\flash\%id_xmbmp_flash%" >NUL
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\flash\%id_xmbmp_flash%" --include "PARAM.SFO" --alter --search "APPTITLID" --replace "%id_xmbmp_flash%"
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\flash\%id_xmbmp_flash%" --include "PARAM.SFO" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --dir "%pkgsource%\flash\%id_xmbmp_flash%\USRDIR\resource" --include "*.new" --alter --search "APPTITLID" --replace "%id_xmbmp%"

echo.
echo CREATING language packs source files ...
echo.
FOR /F "tokens=*" %%A IN ('CHCP') DO FOR %%B IN (%%~A) DO SET CodePage=%%B
chcp 65001 >NUL
if exist "%pkgsource%\languagepacks" rmdir /Q /S "%pkgsource%\languagepacks"
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
echo - %%X language pack source files ...
if not exist "%pkgsource%\languagepacks\%%X\%id_xmbmp%" mkdir "%pkgsource%\languagepacks\%%X\%id_xmbmp%"
xcopy /E "%pkgbasexmbmp%\APPTITLID\*.*" "%pkgsource%\languagepacks\%%X\%id_xmbmp%" >NUL
if exist "%pkgsource%\languagepacks\%%X\%id_xmbmp%\*.pkg" del /Q /S "%pkgsource%\languagepacks\%%X\%id_xmbmp%\*.pkg" >NUL
if exist "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\IMAGES" rmdir /Q /S "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\IMAGES" >NUL
if exist "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\THEMES" rmdir /Q /S "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\THEMES" >NUL
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%" --include "PARAM.SFO" --alter --search "APPTITLID" --replace "%id_xmbmp%"
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%" --include "PARAM.SFO" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
FOR /F "tokens=1,2 delims==" %%G IN (%languageinisdir%\%%X.ini) DO (
FOR /F "tokens=1,2 delims=-" %%E IN ('echo %%G') DO (
FOR /F "tokens=1,2,3 delims=_" %%O IN ('echo %%E') DO (
IF [%%Q]==[MAIN] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR" --include "game_main.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[SETTINGS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[FILEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "File_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEDATAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Game_Data_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Game_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[WEBLINKS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Links.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[MULTIMEDIAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Multimedia_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[PACKAGEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Package_Manager.xml" --alter --search "%%G" --replace "%%H"
IF EXIST "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES\Personal_Area.xml" IF [%%Q]==[PERSONALAREA] %external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR\FEATURES" --include "Personal_Area.xml" --alter --search "%%G" --replace "%%H"
)
)
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "URL-XMBMP-VERSION" --replace "%working_version%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\languagepacks\%%X\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
)
echo.
echo CREATING theme packs source files ...
echo.
if exist "%pkgsource%\themepacks" rmdir /Q /S "%pkgsource%\themepacks"
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasexmbmp%\APPTITLID\USRDIR\IMAGES\*.') DO (
echo - %%Y theme pack source files ...
if not exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%" mkdir "%pkgsource%\themepacks\%%Y\%id_xmbmp%"
xcopy /E "%pkgbasexmbmp%\APPTITLID\*.*" "%pkgsource%\themepacks\%%Y\%id_xmbmp%" >NUL
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFO" --alter --search "APPTITLID" --replace "%id_xmbmp%"
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFO" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
if exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\*.pkg" del /Q /S "%pkgsource%\themepacks\%%Y\%id_xmbmp%\*.pkg" >NUL
if exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\*.xml" del /Q /S "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\*.xml" >NUL
if exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\FEATURES" rmdir /Q /S "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\FEATURES" >NUL
move /Y "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES\%%Y" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\"
if exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" rmdir /Q /S "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" >NUL
echo rename "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\%%Y" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES"
rename %pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\%%Y IMAGES
copy "%pkgbasexmbmp%\APPTITLID\USRDIR\IMAGES\%%Y\themeinfo.xml" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES\themeinfo.xml"
for /f "tokens=1,2 delims=." %%S IN ('dir /b %languageinisdir%\*.ini') DO (
for /f "tokens=1,2 delims==" %%G in (%languageinisdir%\%%S.ini) DO (
IF [%%G]==[LANG_TITL_SETTINGS-THEMES-PACKS-%%Y] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" --include "themeinfo.xml" --alter --search "[%%S]_TITL_SETTINGS-THEMES-PACKS" --replace "%%H"
IF [%%G]==[LANG_INFO_SETTINGS-THEMES-PACKS-%%Y] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" --include "themeinfo.xml" --alter --search "[%%S]_INFO_SETTINGS-THEMES-PACKS" --replace "%%H"
)
)
)
chcp %CodePage% >NUL
echo.
echo CREATING core source files ...
echo.
FOR %%A IN (hdd0 usb000 usb001 usb006) DO (
echo - core %%A source files ...
if exist "%pkgsource%\core-%%A" rmdir /Q /S "%pkgsource%\core-%%A" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%" mkdir "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
xcopy /E "%pkgbasexmbmp%\APPTITLID\*.*" "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%" --include "PARAM.SFO" --alter --search "APPTITLID" --replace "%id_xmbmp%"
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%" --include "PARAM.SFO" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
if exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\*.xml" del /Q /S "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\*.xml" >NUL
if exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" rmdir /Q /S "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" >NUL
if exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" rmdir /Q /S "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" >NUL
xcopy /E "%pkgsource%\languagepacks\en-US\%id_xmbmp%\USRDIR\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" >NUL
xcopy /E "%pkgsource%\themepacks\ORIGINAL\%id_xmbmp%\USRDIR\IMAGES" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES\" >NUL
if not %%A==hdd0 %external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "/dev_hdd0/game/%id_xmbmp%/USRDIR/" --replace "/dev_%%A/PS3/XMB/"
if not %%A==hdd0 del "%pkgsource%\core-%%A\%id_xmbmp%\PARAM.SFO"
if not %%A==hdd0 del "%pkgsource%\core-%%A\%id_xmbmp%\ICON0.PNG"
if not %%A==hdd0 del "%pkgsource%\core-%%A\%id_xmbmp%\PS3LOGO.DAT"
if not %%A==hdd0 mkdir "%pkgsource%\core-%%A\PS3"
if not %%A==hdd0 xcopy "%pkgsource%\core-%%A\%id_xmbmp%" "%pkgsource%\core-%%A\PS3" /s
if not %%A==hdd0 mkdir "%pkgsource%\core-%%A\PS3\XMB"
if not %%A==hdd0 xcopy "%pkgsource%\core-%%A\PS3\USRDIR" "%pkgsource%\core-%%A\PS3\XMB" /s
if not %%A==hdd0 rmdir /s /q "%pkgsource%\core-%%A\%id_xmbmp%"
if not %%A==hdd0 rmdir /s /q "%pkgsource%\core-%%A\PS3\USRDIR" 
)
echo.
echo CREATING HFW core source files ...
echo.
if exist "%pkgsource%\core-HFW" rmdir /Q /S "%pkgsource%\core-HFW" >NUL
if not exist "%pkgsource%\core-HFW\%id_xmbmp%" mkdir "%pkgsource%\core-HFW\%id_xmbmp%" >NUL
xcopy /E "%pkgbasexmbmp%\APPTITLID\*.*" "%pkgsource%\core-HFW\%id_xmbmp%" >NUL
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\core-HFW\%id_xmbmp%" --include "PARAM.SFO" --alter --search "APPTITLID" --replace "%id_xmbmp%"
rem %external%\ssr\ssr --nobackup --dir "%pkgsource%\core-HFW\%id_xmbmp%" --include "PARAM.SFO" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
if exist "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\*.xml" del /Q /S "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\*.xml" >NUL
if exist "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\FEATURES" rmdir /Q /S "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\FEATURES" >NUL
if exist "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\IMAGES" rmdir /Q /S "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\IMAGES" >NUL
xcopy /E "%pkgsource%\languagepacks\en-US\%id_xmbmp%\USRDIR\*.*" "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" mkdir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\IMAGES" >NUL
xcopy /E "%pkgsource%\themepacks\ORIGINAL\%id_xmbmp%\USRDIR\IMAGES" "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\IMAGES\" >NUL
%external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "/dev_hdd0/game/%id_xmbmp%/USRDIR/" --replace "/dev_usb000/XMB/"
%external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" --include "game_main.xml" --alter --search "seg_xmb_hdd0_app" --replace "seg_gamexmb"
%external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search ".pkg" --replace ".rar"
%external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "/CFW/Latest_version_CFW.html" --replace "/4.00_HFW/Latest_version_400.html"
ren "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR\game_main.xml" "xmb.xml"
mkdir "%pkgsource%\core-HFW\XMB"
xcopy "%pkgsource%\core-HFW\%id_xmbmp%\USRDIR" "%pkgsource%\core-HFW\XMB" /s
rmdir /s /q "%pkgsource%\core-HFW\%id_xmbmp%"

echo.
echo CREATING package configuration files ...
echo.
copy "%bindir%\package.conf.template" "%pkgsource%\package-xmbmp.conf"
copy "%bindir%\package.conf.template" "%pkgsource%\package-flash.conf"
%external%\ssr\ssr  --nobackup --encoding auto --dir "%pkgsource%" --include "package-xmbmp.conf" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr  --nobackup --encoding auto --dir "%pkgsource%" --include "package-flash.conf" --alter --search "APPTITLID" --replace "%id_xmbmp_flash%"
%external%\ssr\ssr  --nobackup --encoding auto --dir "%pkgsource%" --include "package-xmbmp.conf" --alter --search "CONTENT_TYPE" --replace "%type_xmbmp%"
%external%\ssr\ssr  --nobackup --encoding auto --dir "%pkgsource%" --include "package-flash.conf" --alter --search "CONTENT_TYPE" --replace "%type_xmbmp_flash%"
%external%\ssr\ssr  --nobackup --encoding auto --dir "%pkgsource%" --include "*.conf" --alter --search "APP_VER = 0.00" --replace "APP_VER = %working_version%"

:done
call "%bindir%\global_messages.bat" "SOURCE-BUILDING-OK"
goto :end

:end
exit
