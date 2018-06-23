# Fix GVim Border (Windows only)

[youtu.be/noLYGZnpWx8](https://www.youtube.com/watch?v=ek1j272iAmc)

## Intro - The Problem

On GVim shows white edges when maximized or snapped to the edges on Windows
(and as far as I know on other platforms as well).

As far as I know there is no solution for this problem unless you use NeoVim
or [full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).

Problem:

[![Fix GVim Border - problem](https://j.gifs.com/mQmERO.gif)](https://www.youtube.com/watch?v=ek1j272iAmc)

Solution:

[![Fix GVim Border - solution](https://j.gifs.com/JqMPD2.gif)](https://www.youtube.com/watch?v=ek1j272iAmc)


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

        " auto detects background color and uses it on the border
        " this works most of the time
        "autocmd GUIEnter * call libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", 0)

        " permanent solution - setup border color by hand using hex format
        " this is recomended solution
        autocmd GUIEnter * call libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", "#002B36")

    endif
```

**The plugin can be loaded only in GVim section.**

**If you put it inside console vim then it may crasch the program.**

If plugin doesn't work try loading it using ``echo`` instead of ``call``
command to see if there are any detected errors:

```vim
    " GVim settings only
    if has("gui_running")
        " use echo instead of call to see returned message
        autocmd GUIEnter * echo libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", 0)
    endif
```

**The plugin can be loaded only ONCE after GVim startup!**

For example if you reload your vimrc after GVim startup you will load the
plugin the second time and may experience memory leaks and glitches
(not tested).

# Thanks

I would like to thank the creator of
[gvim full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).
I'm using it for many years and the source code of this plugin helped me
started this one.

