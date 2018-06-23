@echo off

REM PATH TO THE VISUAL STUDIO TOOLS
set compilerTools32b=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin

REM path to compiler
set compiler="%compilerTools32b%\cl.exe"

REM set up environment
call "%compilerTools32b%\vcvars32.bat"

