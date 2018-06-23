#include <windows.h>
#include "common.h"

typedef LPTSTR (*MYINTPROCSTR)(HINSTANCE, BOOL, COLORREF);
static CHAR _resultBuffer[BUFFER_SIZE];

// Loads main library.
// Does not free loaded library from memory
// (unless some error occurred) and this is intentional.
// The library will free itself when GVim window will close.
LPTSTR _declspec(dllexport) LoadFixGVimBorder(char* color)
{
    // parse color
    BOOL autoDetectBaseColor = TRUE;
    COLORREF baseColor = RGB(0, 0, 0);
    if (color != NULL)
    {
        autoDetectBaseColor = FALSE;
        int len = lstrlen(color);

        // expecting #RRGGBB so 7 chars
        if (len != 7)
        {
            sprintf_s(
                _resultBuffer,
                BUFFER_SIZE,
                "Wrong color string length: %d, expected 7 chars: #RRGGBB",
                len);

            return _resultBuffer;
        }

        int colorInts[7];
        for (int i = 1; i < 7; i++)
        {
            if (color[i] >= '0' && color[i] <= '9')
                colorInts[i] = color[i] - '0';
            else if (color[i] >= 'A' && color[i] <= 'F')
                colorInts[i] = color[i] - 'A' + 10;
            else if (color[i] >= 'a' && color[i] <= 'f')
                colorInts[i] = color[i] - 'a' + 10;

            // error - wrong value
            else
            {
                sprintf_s(
                    _resultBuffer,
                    BUFFER_SIZE,
                    "Wrong color string format. Character: %c is not vali Hex value.",
                    color[i]);

                return _resultBuffer;
            }
        }

        baseColor = RGB(
            16*colorInts[1] + colorInts[2],
            16*colorInts[3] + colorInts[4],
            16*colorInts[5] + colorInts[6]);
    }

    // load main library
    HINSTANCE module = LoadLibraryEx(
        "FixGVimBorder",
        NULL,
        LOAD_LIBRARY_SEARCH_APPLICATION_DIR);

    if (module == NULL)
        return GetLastErrorAsStringMessage("failed to load FixGVimBorder.dll");

    // find initialize function
    MYINTPROCSTR initFunction = (MYINTPROCSTR)GetProcAddress(
        module,
        (LPCSTR)"InitFixBorderHook");

    if (initFunction == NULL)
    {
        FreeLibrary(module);
        return GetLastErrorAsStringMessage("failed to load InitFixBorderHook() function");
    }

    // call initialize function
    LPTSTR initResult = ((MYINTPROCSTR)initFunction)(
        module,
        autoDetectBaseColor,
        baseColor);

    sprintf_s(
        _resultBuffer,
        BUFFER_SIZE,
        "Loaded initFunction: '%s'",
        initResult);

    // return message
    return GetLastErrorAsStringMessage(_resultBuffer);
}

