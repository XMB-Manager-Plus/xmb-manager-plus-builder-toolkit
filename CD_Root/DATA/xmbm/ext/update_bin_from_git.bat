@echo off
title Update bin from git
for /f "tokens=1,2 delims==" %%G in (..\bin\settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
cls
echo.
echo.
cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
cecho {04}        л                                                    л{\n}
cecho {04}        л {0E}                Update bin from git{04}                л{\n}
cecho {04}        л                                                    л{\n}
cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
cecho {04}        л                                                    л{\n}
cecho {04}        л {0C} Attention{0F}, this will:{04}                             л{\n}
cecho {04}        л {0F} - Replace all your bin dir{04}                        л{\n}
cecho {04}        л                                                    л{\n}
cecho {04}        лллллллллллллллллллллллллллллллллллллллллллллллллллллл{\n}
cecho {0F}{\n}
echo.
:ask_confirm
set /P choice= Are you sure (Y/N): 
If /I %choice%==Y goto :ok
If /I %choice%==y goto :ok
If /I %choice%==N goto :first
If /I %choice%==n goto :first
goto :ask_confirm

:ok
rmdir /Q /S "%bindir%"
%external%\wget --no-check-certificate %git_toolkit_page%/zipball/master -O xmbmpbt.zip
%external%\unzip -o -qq xmbmpbt.zip -d "%TEMP%"
move "%TEMP%\XMB-Manager-Plus*" "%TEMP%\xmbmpbt"
move "%TEMP%\xmbmpbt\CD_Root\DATA\xmbm\bin" "%bindir%"
rmdir /Q /S "%TEMP%\xmbmpbt"
del /Q /S xmbmpbt.zip

rmdir /Q /S "%pkgbaseoriginalsources%"
%external%\wget --no-check-certificate %git_base_page%/zipball/master -O xmbmp.zip
%external%\unzip -o -qq xmbmp.zip -d "%TEMP%"
move "%TEMP%\XMB-Manager-Plus*" "%TEMP%\xmbmp"
move "%TEMP%\xmbmp" "%pkgbasesources%"
del /Q /S "%pkgbasesources%\README*"
del /Q /S xmbmp.zip

:end
exit
