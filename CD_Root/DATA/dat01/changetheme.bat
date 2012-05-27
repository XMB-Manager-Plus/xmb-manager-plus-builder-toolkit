@echo off
for /f "tokens=1,2 delims==" %%G in (menu.ini) do set %%G=%%H
if exist "ap5.dat" goto change
if not exist "ap5.dat" goto end 
:change 
rename ap5.dat ap5.old
rename ap6.dat ap5.dat
rename ap7.dat ap6.dat
rename ap8.dat ap7.dat
rename ap5.old ap8.dat
TASKKILL /f /im XMBM+BuilderToolkit.exe
start %menu%\XMBM+BuilderToolkit.exe
goto end
:end
exit
