# Fix GVim Border (Windows only)

[youtu.be/noLYGZnpWx8](https://youtu.be/noLYGZnpWx8)

## Intro - The Problem

GVim shows white edges when maximized or snapped to the edges on Windows
(and as far as I know on other platforms as well).

As far as I know there is no solution for this problem unless you use NeoVim
or [full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).

Problem:

[![Fix GVim Border - problem](https://j.gifs.com/mQmERO.gif)](https://youtu.be/noLYGZnpWx8)

Solution:

[![Fix GVim Border - solution](https://j.gifs.com/JqMPD2.gif)](https://youtu.be/noLYGZnpWx8)


## Configuration

**I will start by saying that the solution is pretty hacky.**

The plugin consists of two ``*.dll`` files.
GVim removes plugin from memory just after using it, so we need two plugins:
 - ``loadfixgvimborder.dll`` - to load the desired plugin into memory
   permanently so it can stay in memory, monitor size change event and fix the
   edges if problem occur
 - ``fixgvimborder.dll    `` - desired plugin which does all work and removes
   itself from memory after Gvim closes

**Repository provides you with precompiled dll libraries
for 32b and 64b system.  But you need to change the name
of the files when copying into GVim installation directory.**

Both dll libraries need to be placed in GVim installation directory.
The default installation directory (for 64 bit system) is:
``C:\Program Files\vim\vim80``

Then we need to put those lines in our vimrc:

```vim
    " GVim settings only
    if has("gui_running")

        "FixGVimBorder
        if $VIM_FULLSCREEN_DLL_FIX
            " dll already loaded, do nothing
        else
            " load the dll fix

            " auto detects background color and uses it on the border
            " this works most of the time
            "autocmd GUIEnter * call libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", 0)

            " permanent solution - setup border color by hand using hex format
            " this is recomended solution
            autocmd GUIEnter * call libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", "#002B36")
            let $VIM_FULLSCREEN_DLL_FIX = 1
        endif


    endif
```

**The plugin can be loaded only in GVim section.**

**If you put it inside console vim then it may crasch the program.**

**The plugin can be loaded only ONCE after GVim startup!**

**NOTE** that the recommeded use sets an environment variable
`$VIM_FULLSCREEN_DLL_FIX` to 1 when the dll loads, which prevents
the dll from being reloaded if you reload your vimrc in the same session.

Reloading the plugin a second time may cause memory leaks and glitches
(not tested).

If plugin doesn't work try loading it using ``echo`` instead of ``call``
command to see if there are any detected errors:

```vim
    " GVim settings only
    if has("gui_running")
        " use echo instead of call to see returned message
        autocmd GUIEnter * echo libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", 0)
    endif
```

# Known problems

There are situations not handled by this plugin:
* there are Themes with different colors for the text area and area after End Of File - plugin uses single color only so this is not handled
* plugin does not stretch the color of visual selection
* the `cursorline` is not handled
* the `colorcolumn` is not handled

## Scrollbar and other GUI elements issues

Because the plugin tries to center the vim text area it may interfere with GUI.
The well know problem is scroll bar.

If you have any problems with GUI elements when using the plugin load it using
`LoadFixGVimBorderWithoutAutocentering` function instead of `LoadFixGVimBorder`.

# Thanks

I would like to thank the creator of
[gvim full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).
I'm using it for many years and the source code of his plugin helped me
started this one.

