


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

        call s:fixGVimBorder(border_color, 0)

    endif

endfunction


function! fixGVimBorder#withColor(border_color)

    if has("gui_running")

        call s:fixGVimBorder(a:border_color, 0)

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

        call s:fixGVimBorder(border_color, 1)

    endif

endfunction


function! DLLIsInstalled(lib_path)

    let dll_installed = len(split(globpath(&rtp, a:lib_path), '\n'))

    return dll_installed && 1

endfunction


function! s:fixGVimBorder(border_color, debug_mode)

    if !exists("g:gvim_border_fixed")
        " load the dll fix

        if has("win32")
            " Fix for Windows
            let first_lib_path = "lib/x86/loadfixgvimborder.dll"
            let second_lib_path = "lib/x86/fixgvimborder.dll"
            if has("win64")
                let first_lib_path = "lib/x64/loadfixgvimborder.dll"
                let second_lib_path = "lib/x64/fixgvimborder.dll"
            endif

            if DLLIsInstalled(first_lib_path) && DLLIsInstalled(second_lib_path)
                let $GVIM_BORDER_FIX_DLL_PATH = split(globpath(&rtp, first_lib_path))[0]
                if a:debug_mode
                    let $GVIM_BORDER_COL = a:border_color
                    autocmd GUIEnter * echom libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorder", $GVIM_BORDER_COL)
                else
                    let $GVIM_BORDER_COL = a:border_color
                    autocmd GUIEnter * call libcall($GVIM_BORDER_FIX_DLL_PATH, "LoadFixGVimBorder", $GVIM_BORDER_COL)
                endif
            else
                " TODO(alex): handle dll not installed error
                return 0
            endif

        else
            " TODO(alex): add support for linux and macos here

        endif
        
        let g:gvim_border_fixed = 1
    else
        " dll already loaded, do nothing
    endif

endfunction


        


