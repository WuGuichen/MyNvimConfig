
" ######### CompileFunctions ##########

noremap sr :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        set splitbelow
        exec "!g++ % -o %<"

        exec "!time ./%<"
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
set laststatus=2
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

if expand('%:t:e') == 'md'
  imap ,. <Esc>I* <Esc>A
  imap ,b <Esc>a****<Esc>hi
  imap ,l <Esc>a**<Esc>i
  imap ，， <Esc>o
  imap jj <Esc>/<++><CR>:nohlsearch<CR>c4l
endif


noremap <LEADER><CR> :nohlsearch<CR>
" 分屏移动
noremap <LEADER>j <C-w>j
noremap <LEADER>h <C-w>h
noremap <LEADER>l <C-w>l
noremap <LEADER>k <C-w>k
noremap <LEADER>t :e ~/.vimrc<CR>
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

" Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }
Plug 'majutsushi/tagbar'


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
" Plug 'neoclide/coc-jedi', {'do': 'yarn install'}

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
nnoremap <silent> <F4> :TagbarToggle<CR> " 将tagbar的开关按键设置为 F4


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


let g:auto_save = 1
let g:auto_save_events = ["TextChangedI", "TextChanged"]
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
let g:UltiSnipsExpandTrigger=",,"
let g:UltiSnipsJumpForwardTrigger=",,"
let g:UltiSnipsJumpBackwardTrigger="<C-J>"


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
set cmdheight=2

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
