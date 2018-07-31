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


The plugin consists of two ``*.dll`` files.
GVim removes plugin from memory just after using it, so we need two plugins:
 - ``loadfixgvimborder.dll`` - to load the desired plugin into memory
   permanently so it can stay in memory, monitor size change event and fix the
   edges if problem occur
 - ``fixgvimborder.dll    `` - desired plugin which does all work and removes
   itself from memory after Gvim closes

**Repository provides you with precompiled dll libraries
for 32bit and 64bit systems (located in lib/x86 and lib/x64).**

These dll's live in the lib directory of the package itself.  No need to 
copy them elsewhere!

## Installation

**Pathogen**  
```
IF NOT EXIST %HOMEPATH%\vimfiles\bundle mkdir %HOMEPATH%\vimfiles\bundle
cd %HOMEPATH%\vimfiles\bundle
git clone https://github.com/azzoam/FixGVimBorder.git
```

Other Vim package managers should work fine, but I have not tested
all of them.

Once installed, all we need is to put these lines in our vimrc:

```vim
execute pathogen#infect()

if has('gui_running')
    " ...
    colorscheme SOME_COLOR_SCHEME
    " ...
endif

call fixGVimBorder#auto()
```
`fixGVimBorder#auto()` will do all the work to autodetect your background
color, load the dll patches, and fill in GVim's borders with the background
color.  

Please **NOTE** that the only requirement for the placement of `call fixGVimBorder#auto()`
is **after** `execute pathogen#infect()` and setting of the colorscheme.

`fixGVimBorder#auto()` can be called either inside or outside of the
`has('gui_running')` block, it does not matter. In console Vim the code does nothing.

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

If plugin doesn't work try the following in your vimrc to see if there are
any detected errors:

```vim
call fixGVimBorder#printErrors()
```


# Thanks

I would like to thank the creator of
[gvim full screen plugin](https://github.com/leonid-shevtsov/gvimfullscreen_win32).
I'm using it for many years and the source code of his plugin helped me
started this one.

