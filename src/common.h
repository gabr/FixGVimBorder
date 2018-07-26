#include <windows.h>
#include <stdio.h>

#define BUFFER_SIZE 255
static CHAR _lastErrorString[BUFFER_SIZE];

LPTSTR GetLastErrorAsStringMessage(LPTSTR msg)
{
    DWORD lastError = GetLastError();
    if (lastError != 0)
        sprintf_s(_lastErrorString, BUFFER_SIZE,
            "Error: '%s', ErrorCode: %d",
            msg, lastError);
    else
        sprintf_s(_lastErrorString, BUFFER_SIZE, "%s", msg);

    return _lastErrorString;
}

