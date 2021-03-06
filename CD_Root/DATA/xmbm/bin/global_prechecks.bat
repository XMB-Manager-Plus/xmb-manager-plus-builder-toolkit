@echo off
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H

call "%bindir%\global_messages.bat" "CHECKING"

IF NOT EXIST "%pkgbasesources%\" (
mkdir "%pkgbasesources%" >NUL
xcopy /E "%pkgbaseoriginalsources%\*.*" "%pkgbasesources%\" >NUL
FOR /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\*.*"') DO (
FOR /f "tokens=1,2 delims=." %%C IN ('dir /b "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\*.rco"') DO (
if not exist "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C" mkdir "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C"
if not exist "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C\Text" mkdir "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C\Text"
if not exist "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C\Images" mkdir "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C\Images"
cd "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C"
"%~dp0\%external%\rcomage\rcomage\rcomage.exe" dump "%~dp0\%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C.rco" "%~dp0\%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C\%%C.xml" --images "Images" --text "Text" --quiet
cd "%~dp0"
del /Q /S "%pkgbasesources%\APPTITLID\USRDIR\apps\XMB Manager Plus\%%X\PS3~dev_flash~vsh~resource\%%C.rco" > NUL
)
)
)


IF NOT EXIST "%pkgsource%\" mkdir "%pkgsource%" >NUL
IF NOT EXIST "%pkgoutput%\" mkdir "%pkgoutput%" >NUL

IF NOT EXIST "%external%\psn_package_npdrm.exe" (
echo "You need to have psn_package_npdrm.exe in \ext directory"
pause
exit 
)

IF NOT EXIST "%external%\scetool\data" (
mkdir "%external%\scetool\data" >NUL
%external%\wget http://www.ps3devwiki.com/files/devtools/scetool/data/keys -O %external%\scetool\data\keys > NUL
%external%\wget http://www.ps3devwiki.com/files/devtools/scetool/data/ldr_curves -O %external%\scetool\data\ldr_curves > NUL
%external%\wget http://www.ps3devwiki.com/files/devtools/scetool/data/vsh_curves -O %external%\scetool\data\vsh_curves > NUL
)
if [%encoding_prep%]==[no] (
reg add HKEY_CURRENT_USER\Console /v FaceName /t REG_SZ /d "Lucida Console" /f >NUL
reg add HKEY_CURRENT_USER\Console /v FontFamily /t REG_DWORD /d 00000036 /f >NUL
reg add HKEY_CURRENT_USER\Console /v FontSize /t REG_DWORD /d 00786432 /f >NUL
reg add HKEY_CURRENT_USER\Console /v FontWeight /t REG_DWORD /d 00000190 /f >NUL
%external%\ssr\ssr --nobackup --recurse --encoding ansi --dir "%bindir%" --include "settings.ini" --alter --search "encoding_prep=no" --replace "encoding_prep=yes"
start "" "%~1"
exit
)
