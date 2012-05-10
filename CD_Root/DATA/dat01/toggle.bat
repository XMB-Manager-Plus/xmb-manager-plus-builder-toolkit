@echo off
if exist ap2.off (
 rename ap2.off ap2.dat
exit
)
if exist ap2.dat 
(
rename ap2.dat ap2.off
exit
)