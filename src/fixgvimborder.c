#include <windows.h>
#include "common.h"

// NOTE(alex):  Autodetection of color is now handled via
// vimscript exclusively.  All c code for this has been 
// deleted to reflect this change.  Autodetection of color
// is now stable.
static WNDPROC _originalWndProc = NULL;
static HINSTANCE _module = NULL;
static HWND _mainWindow = NULL;
static HWND _vimTextArea = NULL;
static CHAR classNameBuffer[BUFFER_SIZE];

static BOOL _hasEdgesProblem = FALSE;
static COLORREF _baseColor = RGB(255, 0, 0);
static BOOL _enableCentering = TRUE;

BOOL CALLBACK FindWindowProc(HWND hwnd, LPARAM lParam);
BOOL CALLBACK FindChildWindowProc(HWND hwnd, LPARAM lParam);
LRESULT CALLBACK SubclassWndProc(HWND hwnd, UINT wm, WPARAM wParam, LPARAM lParam);

// replaces GVim WinProc event loop
LPTSTR _declspec(dllexport) InitFixBorderHook(
    HINSTANCE module,
    COLORREF baseColor,
    BOOL enableCentering)
{
    DWORD dwThreadID;

    // this module variable is an instance of THIS loaded .dll
    // we will use it to clear ourselves from memory
    // on GVim window close or on error
    _module = module;
    _baseColor = baseColor;
    _enableCentering = enableCentering;

    // get handler to main window
    dwThreadID = GetCurrentThreadId();
    EnumThreadWindows(dwThreadID, FindWindowProc, (LPARAM)&_mainWindow);

    if (_mainWindow == FALSE)
    {
        FreeLibrary(_module);
        return GetLastErrorAsStringMessage("main window handle not found");
    }

    // find Vim TextArea window
    EnumChildWindows(_mainWindow, FindChildWindowProc, (LPARAM)&_vimTextArea);
    if (_vimTextArea == FALSE)
    {
        FreeLibrary(_module);
        return GetLastErrorAsStringMessage("Vim TextArea not found");
    }

    // subclass main window
    _originalWndProc = (WNDPROC) SetWindowLongPtr(
        _mainWindow,
        GWLP_WNDPROC,
        (LONG_PTR)SubclassWndProc);

    // all ok
    return GetLastErrorAsStringMessage("should be all ok");
}

// search for main window
BOOL CALLBACK FindWindowProc(HWND hwnd, LPARAM lParam)
{
    HWND* pphWnd = (HWND*)lParam;

    if (GetParent(hwnd))
    {
        *pphWnd = NULL;
        return TRUE;
    }

    *pphWnd = hwnd;
    return FALSE;
}

// search for Vim TextArea child window
BOOL CALLBACK FindChildWindowProc(HWND hwnd, LPARAM lParam)
{
    HWND* pphWnd = (HWND*)lParam;
    *pphWnd = NULL;

    if(GetClassName(hwnd, classNameBuffer, BUFFER_SIZE))
    {
        // if found Vim TextArea then end
        if (lstrcmp(classNameBuffer, "Vim TextArea"))
        {
            *pphWnd = hwnd;
            return FALSE;
        }
    }

    // continue search
    return TRUE;
}

// event loop
LRESULT CALLBACK SubclassWndProc(
    HWND hwnd,
    UINT wm,
    WPARAM wParam,
    LPARAM lParam)
{
    // if closing then free itself from memory
    if (wm == WM_CLOSE || wm == WM_QUIT || (wm == WM_DESTROY && hwnd == _mainWindow))
    {
        if (_module != NULL && FreeLibrary(_module))
            _module = NULL;
    }

    // handle paint but only for main window
    if (wm == WM_PAINT && hwnd == _mainWindow)
    {
        // get hardware device context for main window
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);

        // get client are of main window
        RECT rc;
        GetClientRect(hwnd, &rc);

        // fill whole client area to obtain background color
        HBRUSH hb = CreateSolidBrush(_baseColor);
        FillRect(hdc, &ps.rcPaint, hb);

        // end painting
        EndPaint(hwnd, &ps);
    }

    // NOTE(alex):
    // Bug fix -- White border reappearing on minimize/maximize --
    // Maximize is handled via the WM_SIZE message.  Handling the
    // event explicitly ourselves and posting a WM_PAINT message via
    // RedrawWindow before handing it off to the default window proc
    // restores the desired behavior.
    if (wm == WM_SIZE && wParam == SIZE_MAXIMIZED && hwnd == _mainWindow) {
        RedrawWindow(hwnd, 0, 0, RDW_UPDATENOW | RDW_NOCHILDREN);
    }

    // call default GVim WinProc
    LRESULT result = CallWindowProc(_originalWndProc, hwnd, wm, wParam, lParam);

    // center Vim TextArea in the whole window
    if (wm == WM_SIZE)
    {

        RECT mainRc;
        GetClientRect(hwnd, &mainRc);
        int mainWidth = mainRc.right - mainRc.left;
        int mainHeight = mainRc.bottom - mainRc.top;

        RECT textRc;
        GetClientRect(_vimTextArea, &textRc);
        int textWidth = textRc.right - textRc.left;
        int textHeight = textRc.bottom - textRc.top;

        int xdelta = (mainWidth - textWidth)/2;
        int ydelta = (mainHeight - textHeight)/2;

        _hasEdgesProblem = xdelta > 0 || ydelta > 0;

        // center vimTextArea in main window
        if (_enableCentering && _hasEdgesProblem)
        {
            MoveWindow(
              _vimTextArea,
              textRc.left + xdelta,
              textRc.top + ydelta,
              textWidth,
              textHeight,
              TRUE);
        }

    }

    // return original result from original GVim WinProc
    return result;
}

