@echo off
title Build Source
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
SETLOCAL ENABLEDELAYEDEXPANSION
call "%bindir%\global_messages.bat" "BUILDING"
if exist "%pkgsource%" rmdir /Q /S "%pkgsource%" >NUL
if not exist "%pkgsource%" mkdir "%pkgsource%" >NUL

FOR /F "tokens=*" %%A IN ('CHCP') DO FOR %%B IN (%%~A) DO SET CodePage=%%B
chcp 65001 >NUL

echo.
echo CREATING theme packs source files ...
echo.
if exist "%pkgsource%\themepacks" rmdir /Q /S "%pkgsource%\themepacks"
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\*.') DO (
echo - %%Y theme pack source files ...
if not exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES" mkdir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES"
xcopy /Y "%pkgbasesources%\APPTITLID\ICON0.PNG" "%pkgsource%\themepacks\%%Y\%id_xmbmp%" >NUL
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\%%Y\*.*" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES" >NUL
del /Q /S %pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES\themeinfo.xml >NUL
copy /Y "%pkgbasesources%\APPTITLID\USRDIR\xmbmp\IMAGES\themeinfo.xml" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES\themeinfo.xml" >NUL
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES" --include "themeinfo.xml" --alter --search "THEMENAME" --replace "%%Y"
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES" --include "themeinfo.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\xmbmp\IMAGES" --include "themeinfo.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
copy /Y "%pkgbasesources%\APPTITLID\PARAM-PATCH.SFX" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX" >NUL
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "DESCRIPTION" --replace "Theme Pack (%%Y)"
)

echo.
echo CREATING core source files ...
echo.
echo - Preparing ...
FOR %%A IN (hdd0-cfw hdd0-cfw-full hfw) DO (
if exist "%pkgsource%\core-%%A" rmdir /Q /S "%pkgsource%\core-%%A" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\IMAGES" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\IMAGES" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\xmbmp\*.xml" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\xmbmp\FEATURES\*.xml" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" >NUL
xcopy /E /Y "%pkgsource%\themepacks\%default_theme%\%id_xmbmp%\USRDIR\xmbmp\IMAGES\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\IMAGES\" >NUL
)

FOR %%A IN (hdd0-cfw hdd0-cfw-full) DO (
xcopy /Y "%pkgbasesources%\APPTITLID\*.PNG" "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\PARAM.SFX" "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\EBOOT.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\data" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\data" >NUL
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\data\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\data\*.*" >NUL
if [%%A]==[hdd0-cfw-full] xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resources\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\*.*" >NUL
if [%%A]==[hdd0-cfw] (
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resources\3.55\Normal CFW\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\3.55\Normal CFW\*.*" >NUL
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resources\3.55\Rebug\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\3.55\Rebug\*.*" >NUL
)
)

for /f "tokens=1,2 delims=." %%S IN ('dir /b %languageinisdir%\*.ini') DO (
if exist "%languageinisdir%\%%S.rco.tmp" del /Q /S %languageinisdir%\%%S.rco.tmp >NUL
copy /y NUL %languageinisdir%\%%S.rco.tmp >NUL
for /f "tokens=1,2 delims==" %%G in (%languageinisdir%\%%S.ini) DO (
IF NOT [%%H]==[] echo 	^<Text name^="%%G"^>%%H^</Text^> >> %languageinisdir%\%%S.rco.tmp
)
echo ^</TextLang^> >> %languageinisdir%\%%S.rco.tmp
)

FOR %%A IN (hdd0-cfw hdd0-cfw-full) DO (
echo - core %%A source files ...
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\3.*"') DO (
FOR /f "tokens=1,2 delims=*" %%O IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\*."') DO (
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\*."') DO (
FOR /f "tokens=1,2 delims=." %%E IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C\Text\*.xml"') DO (
set LCODE=%default_lang%
FOR /F "tokens=1,2 delims==" %%G IN (%languageinisdir%\language_map.ini) DO (
IF [%%H]==[%%E] set LCODE=%%G
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C\Text" --include "%%E.xml" --alter --search "/SSR_CR//SSR_LF/</TextLang>" --replace "" >NUL
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C\Text" --include "%%E.xml" --alter --search "</TextLang>" --replace "" >NUL
type %languageinisdir%\!LCODE!.rco.tmp >> %pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%X\%%O\xmbmanpls\rco\%%C\Text\%%E.xml
)
)
)
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Download_*.xml" --alter --search "<Pair key=''info''><String>LANG_INFO_DOWNLOADMANAGER-HOMEBREW-AUTHOR: " --replace "<Pair key=''info''><String>"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "*.xml" --alter --search "<Pair key=''title''><String>LANG" --replace "<Pair key=''title_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "*.xml" --alter --search "<Pair key=''info''><String>LANG" --replace "<Pair key=''info_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "<Pair key=''title''><String>LANG" --replace "<Pair key=''title_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "<Pair key=''info''><String>LANG" --replace "<Pair key=''info_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "<Query class=''type:x-xmb/folder-pixmap'' key=''languages'' attr=''languages'' src=''#seg_settings_languages''/>" --replace ""
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "seg_current_theme_LANGUAGE-CODE" --replace "seg_current_theme"
)
del /Q /S %languageinisdir%\*.tmp >NUL

for /f "tokens=1,2 delims=*" %%A IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "Latest_version_XXX.html" --replace "Latest_version_%%A.html"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search " DESCRIPTION" --replace ""
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "3.55" --replace "3.41"
%external%\ssr\ssr --nobackup --encoding utf8 --recurse --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --recurse --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resources" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
)

FOR %%A IN (hfw) DO (
echo - core %%A source files ...
FOR /F "tokens=1,2 delims==" %%G IN (%languageinisdir%\%default_lang%.ini) DO (
FOR /F "tokens=1,2 delims=-" %%E IN ('echo %%G') DO (
FOR /F "tokens=1,2,3 delims=_" %%O IN ('echo %%E') DO (
IF [%%Q]==[MAIN] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_main.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[SETTINGS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[FILEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "File_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEDATAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Game_Data_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[USERDATAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "User_Data_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Game_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[HOMEBREWMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Homebrew_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[WEBLINKS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Links.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[MULTIMEDIAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Multimedia_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[PACKAGEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Package_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[DOWNLOADMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Download_Manager.xml" --alter --search "%%G" --replace "%%H"
IF EXIST "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES\Personal_Area.xml" IF [%%Q]==[PERSONALAREA] %external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp\FEATURES" --include "Personal_Area.xml" --alter --search "%%G" --replace "%%H"
)
)
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "seg_current_theme_LANGUAGE-CODE" --replace "seg_current_theme_%default_lang%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\resources\3.55\*.') DO (
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resources\3.55\%%Y\xmbmanpls\xml\*.xml" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources\%%Y\*.xml" >NUL
)
%external%\ssr\ssr --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resources" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
%external%\ssr\ssr  --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "/dev_hdd0/game/%id_xmbmp%" --replace "/dev_usb000/PS3/%id_xmbmp%"
%external%\ssr\ssr  --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search ".pkg" --replace ".rar"
)
FOR %%A IN (usb000 usb001 usb006) DO (
xcopy /E /Y "%pkgsource%\core-hfw\*.*" "%pkgsource%\core-%%A\*.*" >NUL
%external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "*.xml" --alter --search "/dev_usb000/PS3/%id_xmbmp%" --replace "/dev_%%A/PS3/%id_xmbmp%"
)

FOR %%A IN (usb000 usb001 usb006 hfw) DO (
%external%\ssr\ssr  --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\xmbmp" --include "game_settings.xml" --alter --search "Latest_version_XXX.html" --replace "Latest_version_%%A.html"
mkdir "%pkgsource%\core-%%A\PS3" >NUL
move /Y "%pkgsource%\core-%%A\%id_xmbmp%" "%pkgsource%\core-%%A\PS3\" >NUL
)
chcp %CodePage% >NUL

echo.
echo CREATING package configuration file ...
echo.
copy "%bindir%\package.conf.template" "%pkgsource%\package-%id_xmbmp%.conf" >NUL
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%.conf" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%.conf" --alter --search "CONTENT_TYPE" --replace "%type_xmbmp%"
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "*.conf" --alter --search "APP_VER = 0.00" --replace "APP_VER = %working_version%"
copy "%pkgsource%\package-%id_xmbmp%.conf" "%pkgsource%\package-%id_xmbmp%-PATCH.conf" >NUL
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%-PATCH.conf" --alter --search "%type_xmbmp%" --replace "%type_xmbmp_patch%"

:done
call "%bindir%\global_messages.bat" "SOURCE-BUILDING-OK"
goto :end

:end
exit
