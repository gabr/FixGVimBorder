#include <windows.h>
#include <string.h>
#include "common.h"

// NOTE(alex):  Autodetection of color is now handled via
// vimscript exclusively.  All c code for this has been 
// deleted to reflect this change.  Autodetection of color
// is now stable.
typedef LPTSTR (*MYINTPROCSTR)(HINSTANCE, COLORREF, BOOL);
static CHAR _resultBuffer[BUFFER_SIZE];

LPTSTR load(char* color, BOOL enableCentering);

LPTSTR _declspec(dllexport) LoadFixGVimBorder(char* color)
{
    return load(color, TRUE);
}

LPTSTR _declspec(dllexport) LoadFixGVimBorderWithoutAutocentering(char* color)
{
    return load(color, FALSE);
}

// Loads main library.
// Does not free loaded library from memory
// (unless some error occurred) and this is intentional.
// The library will free itself when GVim window will close.
LPTSTR load(char* color, BOOL enableCentering)
{
    // parse color
    COLORREF baseColor = RGB(0, 0, 0);
    if (color != NULL)
    {
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


    // NOTE(alex):
    // Automatic determination of fixgvimborder.dll path
    // based on the path of loadfixgvimborder.dll.  Allows
    // the dll's to be installed elsewhere on disk on not
    // limited to Gvim's install directory.
    HMODULE this_dll_handle = GetModuleHandle("loadfixgvimborder");
    char this_dll_path[MAX_PATH];
    GetModuleFileNameA(this_dll_handle, this_dll_path, sizeof(this_dll_path));

    // TODO(alex):
    // Maybe find a cleaner/more reliable way to find the
    // base path?  The following works for now.
    // BEGIN SLIGHTLY JANKY CODE
    char *letter = this_dll_path;
    char *last_slash = this_dll_path;
    while (*letter != 0) {
        if (*letter == '\\') {
            last_slash = letter;
        }
        letter++;
    }

    char base_path[MAX_PATH];
    letter = this_dll_path;
    int i = 0;
    while (letter < last_slash) {
        base_path[i] = *letter;
        letter++;
        i++;
    }

    base_path[i] = '\0';
    // END SLIGHTLY JANKY CODE

    char load_dll_path[MAX_PATH];
    if (strcpy_s(load_dll_path, sizeof(load_dll_path), base_path)) {
        return GetLastErrorAsStringMessage(
                "Failed to build fixgvimborder.dll path.");
    }
    if (strcat_s(load_dll_path, sizeof(load_dll_path), "\\fixgvimborder.dll\0")) {
        return GetLastErrorAsStringMessage(
                "Failed to build fixgvimborder.dll path.");
    }


    // load main library
    HINSTANCE module = LoadLibraryA(load_dll_path);

    if (module == NULL)
        return GetLastErrorAsStringMessage("failed to load fixgvimborder.dll");

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
        baseColor,
        enableCentering);

    sprintf_s(
        _resultBuffer,
        BUFFER_SIZE,
        "Loaded initFunction: '%s'",
        initResult);

    // return message
    return GetLastErrorAsStringMessage(_resultBuffer);
}

