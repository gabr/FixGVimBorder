@echo off

REM set vcvarsall to wherever vcvarsall.bat is located
set vcvarsall="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"

IF "%1"=="32" (
    set build32="YES"
    set build64="NO"
) ELSE (
    set build32="NO"
    set build64="YES"
)

REM create necessary folders
if not exist ".\lib" mkdir ".\lib"
if not exist ".\lib\x86" mkdir ".\lib\x86"
if not exist ".\lib\x64" mkdir ".\lib\x64"

REM set params
set params=/LD /Fo: .\lib\ /Fd: .\lib\ /EHsc /W4 /WX /Oy /O2

REM params explanation (hashed out are not ussed):
REM /LD   - create .dll library
REM /Fo   - output path for .obj files
REM /Fe   - output path for binary result
REM /Fd   - output path for .pdb files
REM /EHsc - turns on automatic exception handling (compiler is angry if not set)
REM # /Wall - shows ALL ALL warnings
REM /Wn   - show level n warnings
REM /WX   - turns warnings into errors
REM # /Zi   - additional informations for compiler
REM /Oy   - maximum optimizations
REM /O2   - maximize speed

IF %build32%=="YES" (
    REM 32-bit compile
    call %vcvarsall% x86
    cl %params% /Fe: .\lib\x86\fixgvimborder.dll .\src\fixgvimborder.c user32.lib Gdi32.lib
    cl %params% /Fe: .\lib\x86\loadfixgvimborder.dll .\src\loadfixgvimborder.c user32.lib

    del .\lib\x86\*exp
    del .\lib\x86\*lib
)

IF %build64%=="YES" (
    REM 64-bit compile
    call %vcvarsall% x64
    cl %params% /Fe: .\lib\x64\fixgvimborder.dll .\src\fixgvimborder.c user32.lib Gdi32.lib
    cl %params% /Fe: .\lib\x64\loadfixgvimborder.dll .\src\loadfixgvimborder.c user32.lib

    del .\lib\x64\*exp
    del .\lib\x64\*lib
)

del .\lib\*obj


