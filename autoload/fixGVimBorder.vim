


function! fixGVimBorder#auto(...)

    if a:0 == 0
        let border_color = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
    elseif a:0 == 1
        let border_color = a:1
    else
        " TODO(alex): handle this error
        return 0
    endif

    call fixGVimBorder#withColor(border_color)

endfunction


function! fixGVimBorder#withColor(border_color)

    if has("gui_running")

        if !exists("g:gvim_border_fixed")
            " load the dll fix

            if has("win32")
                " Fix for Windows
                let $VIM_BORDER_COL = a:border_color
                autocmd GUIEnter * call libcall("win32_loadfixgvimborder.dll", "LoadFixGVimBorder", $VIM_BORDER_COL)

            else
                " TODO(alex): add support for linux and macos here

            endif
            
            let g:gvim_border_fixed = 1
        else
            " dll already loaded, do nothing
        endif

    endif

endfunction
        


