
" ######### CompileFunctions ##########

noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
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

set ttimeoutlen=150
"退出插入模式
autocmd InsertLeave * call Fcitx2en()
"进入插入模式
autocmd InsertEnter * call Fcitx2zh()
"##### auto fcitx end ######

set fileencoding=utf-8

set mouse=a
set encoding=utf-8
let &t_ut=''
set expandtab
set tabstop=2
set shiftwidth=2
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

map st :NERDTreeToggle<CR>



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

if expand('%:t:e') == 'md'
  imap .. <Esc>I> <Esc>A
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


"===================
"### Error check ###
"===================

Plug 'w0rp/ale'


"====================
"### autocomplete ###
"====================

"Plug 'neoclide/coc.nvim', {'branch': 'release'}


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
Plug 'gisphm/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] }


"=============================================
"### HTML, CSS, JavaScript, PHP, JSON, etc ###
"=============================================


"==============
"### Python ###
"==============



"================
"### Markdown ###
"================

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


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
Plug 'scrooloose/nerdcommenter' " in <space>cc to comment a line


"====================
"### Dependencies ###
"====================

Plug 'mzlogin/vim-markdown-toc'
Plug 'ferrine/md-img-paste.vim'
Plug '907th/vim-auto-save'


"===========================================================
"### A Vim Plugin for Lively Previewing LaTeX PDF Output ###
"===========================================================

"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"Plug 'lervag/vimtex'

call plug#end()

let g:markdown_preview_sync_firefox_path = "C:\Program Files\Mozilla Firefox"

let g:auto_save = 1
let g:auto_save_events = ["TextChangedI", "TextChanged"]
" autocmd TextChanged,TextChangedI <buffer> silent write

"使vimtex默认xelatex为编译器
"let g:tex_flavor='latex'
"let g:vimtex_view_method='zathura'
"if has('nvim')
"  let g:vimtex_compiler_progname='nvr'
"endif
"let g:vimtex_quickfix_mode=0
"set conceallevel=1
"let g:tex_conceal='abdmg'



let g:python_slow_sync = 0
"let g:coc_disable_startup_warning = 1
let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_start = 1
let g:mkdp_delay_start_browser = 800
"let g:mkdp_delay_auto_refresh = 3000

let g:vim_markdown_math = 1

"UltiSnips 设置tab键为触发键
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"设置打开配置文件时为垂直打开
let g:UltiSnipsEditSplit="vertical"

" ===
" === MarkdownPreview
" ===
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
