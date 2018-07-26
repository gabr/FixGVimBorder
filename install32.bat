REM Install GVim border fix dlls to 32-bit VIM
@echo off

REM Set the variable VIMRUNTIME to wherever the
REM gvim.exe is located, usually at the following
set VIMRUNTIME=C:\Program Files (x86)\Vim\vim80

copy .\lib\x86\fixgvimborder.dll "%VIMRUNTIME%\fixgvimborder.dll"
copy .\lib\x86\loadfixgvimborder.dll "%VIMRUNTIME%\loadfixgvimborder.dll"
