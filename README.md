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
for 32b and 64b system (located in lib/x86 and lib/x64).**

## Installation

**Pathogen**  
```
IF NOT EXIST %HOMEPATH%\vimfiles\bundle mkdir %HOMEPATH%\vimfiles\bundle
cd %HOMEPATH%\vimfiles\bundle
git clone https://github.com/azzoam/FixGVimBorder.git
```

Additionally, both dll libraries need to be placed in GVim installation directory.
The default installation directory (for 64 bit system) is:
``C:\Program Files\vim\vim80``

You can run either `install32.bat` or `install64.bat` as admin,
or copy them yourself.

Once installed, all we need is to put these lines in our vimrc:

```vim
execute pathogen#infect()
call fixGVimBorder#auto()
```

## Customization

The vimrc above will autodetect your background color and fill the screen 
border with it.  If you experience issues, or wish to specificy the color
yourself, simply pass a hex color to fixGVimBorder like below.

```vim
call fixGVimBorder#auto("#FF0000")
```
or
```vim
call fixGVimBorder#withColor("#FF0000")
```

**NOTE** that calling the patch in this way prevents the dll from being reloaded
if you reload your vimrc in the same session, and also ensures the patch is
only loaded inside GVim and not console vim.  In console Vim the code does nothing.

If plugin doesn't work try loading it using ``echo`` instead of ``call``
command to see if there are any detected errors:

```vim
    " GVim settings only
    if has("gui_running")
        " use echo instead of call to see returned message
        autocmd GUIEnter * echo libcall("loadfixgvimborder.dll", "LoadFixGVimBorder", 0)
    endif
```


# Thanks

I would like to thank the creator of
[gvim full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).
I'm using it for many years and the source code of his plugin helped me
started this one.

