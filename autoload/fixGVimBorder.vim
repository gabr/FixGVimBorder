
function! fixGVimBorder#auto(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        if &go =~ "m" || &go =~ "T" || &go =~ "r" || &go =~ "L"
            call fixGVimBorder#noCenter(border_color)
        else
            call fixGVimBorder#center(border_color)
        endif

    endif

endfunction

function! fixGVimBorder#center(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        call s:fixGVimBorder(border_color, 1, 0)

    endif

endfunction

function! fixGVimBorder#noCenter(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        call s:fixGVimBorder(border_color, 0, 0)

    endif

endfunction

function! fixGVimBorder#withColor(border_color)

    if has("gui_running")

        call fixGVimBorder#auto(a:border_color)

    endif

endfunction

function! fixGVimBorder#withColorCenter(border_color)

    if has("gui_running")

        call fixGVimBorder#center(a:border_color)

    endif

endfunction

function! fixGVimBorder#withColorNoCenter(border_color)

    if has("gui_running")

        call fixGVimBorder#noCenter(a:border_color)

    endif

endfunction

function! fixGVimBorder#printErrors(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        if &go =~ "m" || &go =~ "T" || &go =~ "r" || &go =~ "L"
            call fixGVimBorder#printErrorsNoCenter(border_color)
        else
            call fixGVimBorder#printErrorsCenter(border_color)
        endif

    endif

endfunction

function! fixGVimBorder#printErrorsCenter(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        call s:fixGVimBorder(border_color, 1, 1)

    endif

endfunction

function! fixGVimBorder#printErrorsNoCenter(...)

    if has("gui_running")

        if a:0 == 0
            let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        elseif a:0 == 1
            let border_color = a:1
        else
            " TODO(alex): handle this error
            return 0
        endif

        call s:fixGVimBorder(border_color, 0, 1)

    endif

endfunction


function! DLLIsInstalled(lib_path)

    let dll_installed = len(split(globpath(&rtp, a:lib_path), '\n'))

    return dll_installed && 1

endfunction


function! s:fixGVimBorder(border_color, auto_center, debug_mode)

    if !exists("g:gvim_border_fixed")
        " load the dll fix

        if has("win32")
            " Fix for Windows
            call s:Win32Fix(a:border_color, a:auto_center, a:debug_mode)
        else
            " TODO(alex): add support for linux and macos here

        endif
        
        let g:gvim_border_fixed = 1
    else
        " dll already loaded, do nothing
    endif

endfunction

function! s:Win32Fix(border_color, auto_center, debug_mode)

    let first_lib_path = "lib/x86/loadfixgvimborder.dll"
    let second_lib_path = "lib/x86/fixgvimborder.dll"
    if has("win64")
        let first_lib_path = "lib/x64/loadfixgvimborder.dll"
        let second_lib_path = "lib/x64/fixgvimborder.dll"
    endif

    if DLLIsInstalled(first_lib_path) && DLLIsInstalled(second_lib_path)
        let $GVIM_BORDER_FIX_DLL_PATH = split(globpath(&rtp, first_lib_path))[0]
        if a:debug_mode
            if a:auto_center
                let $GVIM_BORDER_COL = a:border_color
                autocmd GUIEnter * echom libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorder", $GVIM_BORDER_COL)
            else
                let $GVIM_BORDER_COL = a:border_color
                autocmd GUIEnter * echom libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorderWithoutAutocentering", $GVIM_BORDER_COL)
            endif
        else
            if a:auto_center
                let $GVIM_BORDER_COL = a:border_color
                autocmd GUIEnter * call libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorder", $GVIM_BORDER_COL)
            else
                let $GVIM_BORDER_COL = a:border_color
                autocmd GUIEnter * call libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorderWithoutAutocentering", $GVIM_BORDER_COL)
            endif
        endif
    else
        " TODO(alex): handle dll not installed error
        return 0
    endif

endfunction



        


