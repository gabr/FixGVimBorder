if "%1"=="32" (
    call initBuild32b.bat
) else (
    call initBuild64b.bat
)

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

    copy /Y bin\fixgvimborder.dll  "C:\Program Files\vim\vim80"
    copy /Y bin\loadfixgvimborder.dll  "C:\Program Files\vim\vim80"

    copy /Y bin\fixgvimborder.dll  .
    copy /Y bin\loadfixgvimborder.dll  .

    if "%1"=="32" (
        copy /Y bin\fixgvimborder.dll fixgvimborder32.dll
        copy /Y bin\loadfixgvimborder.dll loadfixgvimborder32.dll
    ) else (
        copy /Y bin\fixgvimborder.dll fixgvimborder64.dll
        copy /Y bin\loadfixgvimborder.dll loadfixgvimborder64.dll
    )

    REM cleanup after successfull compilation
    call clean.bat >nul 2>&1
)

