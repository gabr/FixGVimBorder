@echo off

REM PATH TO THE VISUAL STUDIO TOOLS
set compilerTools64b=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64

REM path to compiler
set compiler="%compilerTools64b%\cl.exe"

REM set up environment
call "%compilerTools64b%\vcvars64.bat"

