@echo off
for /f "tokens=1,2 delims==" %%G in (menu.ini) do set %%G=%%H
if exist "ap2.off" goto on
if not exist "ap2.off" goto off 
:on 
rename ap2.off ap2.dat
rename ap1.off ap1.dat
goto end
:off
rename ap2.dat ap2.off
TASKKILL /f /im XMBM+BuilderToolkit.exe
rename ap1.dat ap1.off
start %menu%\XMBM+BuilderToolkit.exe
goto end
:end
exit
