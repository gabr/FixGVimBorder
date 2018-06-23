call initBuild64b.bat
REM call initBuild32b.bat

REM cleanup before compilation
call clean.bat >nul 2>&1

REM create necessary folders
if not exist ".\bin" mkdir ".\bin"

REM set params
set params=/LD /Fo: .\bin\ /Fd: .\bin\ /EHsc /W4 /WX /Oy /O2

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


REM compile
%compiler% %params% /Fe: .\bin\fixgvimborder.dll fixgvimborder.c user32.lib Gdi32.lib
%compiler% %params% /Fe: .\bin\loadfixgvimborder.dll loadfixgvimborder.c user32.lib

REM if no errors then copy files to the vim directory
if NOT ERRORLEVEL 1 (
    echo.

    del "C:\Program Files\vim\vim80\fixgvimborder.dll"
    copy bin\fixgvimborder.dll  .
    copy bin\fixgvimborder.dll  "C:\Program Files\vim\vim80"

    del "C:\Program Files\vim\vim80\loadfixgvimborder.dll"
    copy bin\loadfixgvimborder.dll  .
    copy bin\loadfixgvimborder.dll  "C:\Program Files\vim\vim80"

    REM cleanup after successfull compilation
    call clean.bat >nul 2>&1
)

