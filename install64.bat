REM Install GVim border fix dlls to 64-bit VIM
@echo off

REM Set the variable VIMRUNTIME to wherever the
REM gvim.exe is located, usually at the following
set VIMRUNTIME=C:\Program Files\Vim\vim80

copy .\lib\x64\fixgvimborder.dll "%VIMRUNTIME%\fixgvimborder.dll"
copy .\lib\x64\loadfixgvimborder.dll "%VIMRUNTIME%\loadfixgvimborder.dll"
