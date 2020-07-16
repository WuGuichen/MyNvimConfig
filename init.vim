" ######### For MarkdownPreview ##########

" sudo npm install tslib neovim log4js socket.io msgpack-lite

"------------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
"------------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif
 
"------------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
"------------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
 
"------------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
"------------------------------------------------------------------------------
" F9 一键保存、编译、连接存并运行
map sR :call Run()<CR>
imap sR <ESC>:call Run()<CR>
 
" Ctrl + F9 一键保存并编译
map <c-F9> :call Compile()<CR>
imap <c-F9> <ESC>:call Compile()<CR>
 
" Ctrl + F10 一键保存并连接
map <c-F10> :call Link()<CR>
imap <c-F10> <ESC>:call Link()<CR>
 
let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0
 
let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
 
let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
 
func! Compile()
    exe ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        let Obj_Name = expand("%:p:t:r").s:Obj_Extension
        let v:statusmsg = ''
        if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
            if expand("%:e") == "c"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CFlags
                else
                    exe ":setlocal makeprg=".s:linux_CFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CPPFlags
                else
                    exe ":setlocal makeprg=".s:linux_CPPFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_C = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_C != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " compilation failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " compilation successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " compilation successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
        let s:Sou_Error = 1
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    exe ":setlocal makeprg=make"
endfunc
 
func! Link()
    call Compile()
    if s:Sou_Error || s:LastShellReturn_C != 0
        return
    endif
    let s:LastShellReturn_L = 0
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
        let Exe_Name = expand("%:p:t:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
        let Exe_Name = expand("%:p:t:r")
    endif
    let v:statusmsg = ''
    if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        redraw!
        if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
            if expand("%:e") == "c"
                setlocal makeprg=gcc\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                setlocal makeprg=g++\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_L = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_L != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " linking successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " linking successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Exe_Name"is up to date"
        endif
    endif
    setlocal makeprg=make
endfunc
 
func! Run()
    let s:ShowWarning = 0
    call Link()
    let s:ShowWarning = 1
    if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
        return
    endif
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
    endif
    if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
        redraw!
        echohl WarningMsg | echo " running..."
        if g:iswindows
            exe ":!%<.exe"
        else
            if g:isGUI
                exe ":!gnome-terminal -e ./%<"
            else
                set splitbelow
                :sp
                :res -8
                exec "term ./%<"
            endif
        endif
        redraw!
        echohl WarningMsg | echo " running finish"
    endif
endfunc

" ######### CompileFunctions ##########

noremap sr :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        " set splitbelow
        " exec "!g++ -std=c++11 % -Wall -o %<"
        " :sp
        " :res -8
        " exec "term ./%<"
        :call Run()
        normal a
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        set splitbelow
        :sp
        :term python3 %
    elseif &filetype == 'html'
        silent! exec "!".g:mkdp_browser." % &"
    elseif &filetype == 'markdown'
        exec "MarkdownPreview"
    elseif &filetype == 'tex'
        silent! exec "VimtexStop"
        silent! exec "VimtexCompile"
    elseif &filetype == 'dart'
        exec "CocCommand flutter.run -d ".g:flutter_default_device
        CocCommand flutter.dev.openDevLog
    elseif &filetype == 'javascript'
        set splitbelow
        :sp
        :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
    elseif &filetype == 'go'
        set splitbelow
        :sp
        :term go run .
    endif
endfunc


" ######### Auto load in first time ##########
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader = " "

set norelativenumber
set wrap
set cursorline
set number
set modifiable
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

set showcmd
set wildmenu

set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8

"##### auto fcitx  ###########
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endfunction

set noswapfile
set ttimeoutlen=150
"退出插入模式
autocmd InsertLeave * call Fcitx2en()
"进入插入模式
autocmd InsertEnter * call Fcitx2zh()
"##### auto fcitx end ######

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

set fileencoding=utf-8

set mouse=a
set encoding=utf-8
let &t_ut=''
set expandtab
set tabstop=4
set ts=4
set expandtab
set shiftwidth=4
set softtabstop=2
set list 
set listchars=tab:▸\ ,trail:▫
set scrolloff=9
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" ################# 状态栏设置 #####################

set laststatus=2
set t_Co=256      "在windows中用xshell连接打开vim可以显示色彩

" ################# 状态栏 结束 ####################
set autochdir
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
set tw=0
set foldmethod=indent


map s <nop>
map sq :q!<CR>
map S :w<CR>
map R :source $MYVIMRC<CR>

map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sk :set nosplitbelow<CR>:split<CR>
map sj :set splitbelow<CR>:split<CR>

map sV <C-w>t<C-w>H
map sH <C-w>t<C-w>K

map <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l

" 寻找两个相等的单词
map <LEADER>fd /\(\<\w\+\>\)\_s*\1

"================= 根据文件类型映射按键 =================
if expand('%:t:e') == 'md'
  imap ,. <Esc>I* <Esc>A
  imap ,b <Esc>a****<Esc>hi
  imap ,l <Esc>a**<Esc>i
  imap jj <Esc>/<++><CR>:nohlsearch<CR>c4l
  " xdot
  imap ,, <Esc>:!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>a
  imap ，， <Esc>:!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>a
  nmap ,, :!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>

  " map sp :call PlayAndPause()<CR>
  " func! PlayAndPause()
    " exec "!time xdotool key Alt+Tab sleep 0.2 mousemove 1100 540 click 1 key Alt+Tab"
  " endfunc

  """""
endif

if expand('%:t:e') == 'cpp'

    imap ,, <Esc>:!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>a
    imap ，， <Esc>:!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>a
    nmap ,, :!time xdotool key Alt+Tab sleep 0.15 mousemove 1100 540 click 1 key Alt+Tab<CR><CR>
endif

" =================== end =========================

noremap <LEADER><CR> :nohlsearch<CR>
" 分屏移动
noremap <LEADER>j <C-w>j
noremap <LEADER>h <C-w>h
noremap <LEADER>l <C-w>l
noremap <LEADER>k <C-w>k
" noremap <LEADER>t :e ~/.vimrc<CR>
" 分屏大小
map <up> :res +3<CR>
map <down> :res -3<CR>
map <left> :vertical resize -3<CR>
map <right> :vertical resize +3<CR>

map ttt :tabe<CR>
map th :-tabnext<CR>
map tl :+tabnext<CR>

map tx :r !figlet 

map Tv :e ~/.config/nvim/init.vim<CR>

" 映射全选+复制 ctrl+a
imap <C-a> <Esc>ggVG
nmap <C-a> ggVG
vmap <C-a> ggG
map <F12> <nop>

"将选中文本块复制到系统剪贴板
vnoremap <LEADER>y "+y

"将系统剪贴板内容粘贴到vim
nmap <LEADER>p "+p"


"共享剪贴板  
set clipboard+=unnamed

" 历史记录数
set history=1000

"自动补全
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {<CR>}<ESC>O
":inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap " ""<ESC>i
":inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu


"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" add header comments for .h .c .hpp .cpp .mk .sh new file
" auto call SetTitle func
autocmd BufNewFile *.[ch],*.hpp,*.cpp,Makefile,*.mk,*.sh,*.py exec ":call SetTitle()"
 
" " add comment for cpp
" func SetComment_ch()
"     call setline(1,"/*================================================================")
"     call append(line("."),   "*   Copyright (C) ".strftime("%Y")." * Ltd. All rights reserved.")
"     call append(line(".")+1, "*   ")
"     call append(line(".")+2, "*   File name   : ".expand("%:t"))
"     call append(line(".")+3, "*   Author      : longbin")
"     call append(line(".")+4, "*   Created date: ".strftime("%F %T"))
"     call append(line(".")+5, "*   Description : ")
"     call append(line(".")+6, "*")
"     call append(line(".")+7, "*===============================================================*/")
"     call append(line(".")+8, "")
"     call append(line(".")+9, "")
" endfunc
"
" " add comment for shell,Makefile
" func SetComment_sh()
"     call setline(3, "#================================================================")
"     call setline(4, "#   Copyright (C) ".strftime("%Y")." * Ltd. All rights reserved.")
"     call setline(5, "#   ")
"     call setline(6, "#   File name   : ".expand("%:t"))
"     call setline(7, "#   Author      : longbin")
"     call setline(8, "#   Created date: ".strftime("%F %T"))
"     call setline(9, "#   Description : ")
"     call setline(10, "#")
"     call setline(11, "#================================================================")
"     call setline(12, "")
"     call setline(13, "")
" endfunc
"
" SetTitle func, add comment
func SetTitle()

    call append(line(".")+1, "*   ")
    call append(line(".")+2, "*   Author      : longbin")
    call append(line(".")+3, "*   Created date: ".strftime("%F %T"))
    call append(line(".")+5, "*   Description : ")
    call append(line(".")+6, "*")
    if &filetype == 'make'
        call setline(1,"")
        call setline(2,"")
        " call SetComment_sh()
    elseif &filetype == 'sh'
        call setline(1,"#! /bin/bash")
        call setline(2,"")
        " call SetComment_sh()
 
    elseif &filetype == 'python'
        call setline(1,"#! /usr/bin/env python")
        call setline(2,"# coding=utf-8")
        call setline(3,"")
        " call SetComment_sh()
 
    else

        if expand("%:e") == 'hpp'
            call append(line(".")+10, "#ifndef _".toupper(expand("%:t:r"))."_H")
            call append(line(".")+11, "#define _".toupper(expand("%:t:r"))."_H")
            call append(line(".")+12, "#ifdef __cplusplus")
            call append(line(".")+13, "extern \"C\"")
            call append(line(".")+14, "{")
            call append(line(".")+15, "#endif")
            call append(line(".")+16, "")
            call append(line(".")+17, "#ifdef __cplusplus")
            call append(line(".")+18, "}")
            call append(line(".")+19, "#endif")
            call append(line(".")+20, "#endif //".toupper(expand("%:t:r"))."_H")
 
        elseif expand("%:e") == 'h'
            call append(line(".")+10, "#pragma once")
 
        elseif expand("%:e") == 'c'
            call append(line(".")+10,"#include \"".expand("%:t:r").".h\"")
 
        elseif expand("%:e") == 'cpp'
            call setline(1,"#include<bits/stdc++.h>")
            call append(line("."), "using namespace std;")
            call append(line(".")+1,"<++>")
" #include<bits/stdc++.h" >
" 2 using namespace std;
" 3
" 4 int main(){
" 5
" 6     return 0;
" 7 }
        elseif expand("%:e") == 'py'
        endif
    endif
endfunc

"===================== Plugs ============================
call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'


"=======================
"### File navigation ###
"=======================

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'


"================
"### Tag list ###
"================

Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }
" Plug 'majutsushi/tagbar'


"===================
"### Error check ###
"===================

Plug 'w0rp/ale'


"====================
"### autocomplete ###
"====================

" Or build from source code by using yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-jedi', {'do': 'yarn install'}

"====================
"### auto comment ###
"====================

Plug 'scrooloose/nerdcommenter'


"=================
"### Undo tree ###
"=================

Plug 'mbbill/undotree/'


"================================
"### Other visual enhancemnet ###
"================================

Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/vim-cursorword'


"===========
"### git ###
"===========

Plug 'rhysd/conflict-marker.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
"Plug 'gisphm/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] }


"=============================================
"### HTML, CSS, JavaScript, PHP, JSON, etc ###
"=============================================


"==============
"### Python ###
"==============

"=====================
"### C++ highlight ###
"=====================

Plug 'octol/vim-cpp-enhanced-highlight'



"================
"### Markdown ###
"================

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"=============
"### theme ###
"=============

Plug 'crusoexia/vim-monokai'
Plug 'connorholyday/vim-snazzy'

"=================
"### Bookmarks ###
"=================

Plug 'kshenoy/vim-signature'

"================
"### debugger ###
"================

Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python --enable-go'}


"==============================
"### Other useful utilities ###
"==============================

Plug 'terryma/vim-multiple-cursors'
"Plug 'junegunn/goyo.vim' " distraction free writing mode
Plug 'tpope/vim-surround' " type ysks' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'godlygeek/tabular' " type ;Tabularize /= to align the =
Plug 'plasticboy/vim-markdown'
Plug 'gcmt/wildfire.vim' " in Visual mode, type i' to select all text in '', or type i) i] i} ip
Plug 'kien/rainbow_parentheses.vim'


"====================
"### Dependencies ###
"====================

Plug 'mzlogin/vim-markdown-toc'
Plug 'ferrine/md-img-paste.vim'
Plug '907th/vim-auto-save'


"===========
"### 对齐线 ###
"===========
Plug 'Yggdroot/indentLine'

"================
"### coc美化状态栏 ###
"================

" Plug 'liuchengxu/eleline.vim'


"===========================================================
"### A Vim Plugin for Lively Previewing LaTeX PDF Output ###
"===========================================================

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'lervag/vimtex'

call plug#end()

"let g:markdown_preview_sync_firefox_path = "C:\Program Files\Mozilla Firefox"

" ######### theme ##########

"colo monokai
"colorscheme snazzy
"colorscheme onedark
"let g:SnazzyTransparent = 1
"let g:lightline = {
"\ 'colorscheme': 'snazzy',
"\ }


" ######### undotree ##########

if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif
nnoremap <leader>u :UndotreeToggle<cr>


" ######### nerdtree ##########

nmap st : NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=1
" 设置宽度
let NERDTreeWinSize=31
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 显示书签列表
let NERDTreeShowBookmarks=1

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" ######### Tag list/ tagbar ##########

let g:tagbar_width=30
    nnoremap <silent> <leader>t :TagbarToggle<CR> " 将tagbar的开关按键设置为 F4


" ######### airline ##########

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'

" 是否打开tabline
let g:airline#extensions#tabline#enabled = 1



" ######### rainbow_parentheses ##########
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

" 不加入这行, 防止黑色括号出现, 很难识别
" \ ['black',       'SeaGreen3'],

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


" ######### auto_save ##########

"自动保存
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged", "TextChangedI", "CursorHoldI", "CompleteDone"]
" autocmd TextChanged,TextChangedI <buffer> silent write

" ######### LaTeX ##########

autocmd filetype tex setl updatetime=1000
let g:livepreview_previewer = 'zathura'
autocmd filetype tex :LLPStartPreview
nmap <F6> :LLPStartPreview<CR>
imap <F6> <ESC>:LLPStartPreview<CR>

let g:livepreview_engine = 'xelatex'
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor='latex'
"let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'



" ######### auto comment ##########

"add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" python 自动的会多加一个空格
au FileType python let g:NERDSpaceDelims = 0

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" ######### other ##########

let g:python_slow_sync = 0
"let g:coc_disable_startup_warning = 1
let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_start = 1
let g:mkdp_delay_start_browser = 800
"let g:mkdp_delay_auto_refresh = 3000

let g:vim_markdown_math = 1

"UltiSnips 设置tab键为触发键
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


"设置打开配置文件时为垂直打开
let g:UltiSnipsEditSplit="vertical"


" ######### MarkdownPreview Setting ##########
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
            \ 'mkit': {},
            \ 'katex': {},
            \ 'uml': {},
            \ 'maid': {},
            \ 'disable_sync_scroll': 0,
            \ 'sync_scroll_type': 'middle',
            \ 'hide_yaml_meta': 1
            \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'


" ######### Ruby ##########
let g:ruby_host_prog = '/home/wgc/.gem/ruby/2.7.0/bin/neovim-ruby-host'


" ######### coc setting ##########
"call dein#add('neoclide/coc.nvim', {'merged':0, 'rev': 'release'})
"call dein#add('neoclide/coc.nvim', {'merged':0, 'build': 'yarn install --frozen-lockfile'})

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:checunction_name()
    " code
endf
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-j> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" ######### vimspector ##########

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
function! s:read_template_into_buffer(template)
    " has to be a function to avoid the extra space fzf#run insers otherwise
    execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
            \   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
            \   'down': 20,
            \   'sink': function('<sid>read_template_into_buffer')
            \ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
sign define vimspectorBP text=☛ texthl=Normal
sign define vimspectorBPDisabled text=☞ texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad


