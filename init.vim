" ######### For MarkdownPreview ##########

" sudo npm install tslib neovim log4js socket.io msgpack-lite



" ######### 大括号自动换行 ##########

" 大括号自动分行, C/C++下的自动命令, 添加到 .vimrc
autocmd BufWritePre,BufRead *.c :inoremap <Enter> <c-r>=BracketsEnter('}')<CR>
autocmd BufWritePre,BufRead *.cpp :inoremap <Enter> <c-r>=BracketsEnter('}')<CR>
" autocmd BufEnter *.cpp :inoremap <Enter> <c-r>=BracketsEnter('}')<CR>

function BracketsEnter(char)
    if getline('.')[col('.')-1] == a:char
        return "\<Enter>\<Tab>\<Esc>mpa\<Enter>\<Esc>`pa" 
    else
        return "\<Enter>"
    endif
endf


" ######### buffers ##########

nmap <leader>l :bnext<CR>;
nmap <leader>h :bprev<CR>;


" ######### yank ##########

" sudo pacman -S xsel
vnoremap Y "+y


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
set relativenumber
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
   let s:input_status = system("fcitx5-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx5-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx5-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx5-remote -o")
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

function! Refresh()
    exec "mapclear"
    exec "source $MYVIMRC<"
endfunction


map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sk :set nosplitbelow<CR>:split<CR>
map sj :set splitbelow<CR>:split<CR>

map sV <C-w>t<C-w>H
map sH <C-w>t<C-w>K

map <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l
imap jj <Esc>/<++><CR>:nohlsearch<CR>c4l

" 寻找两个相等的单词
map <LEADER>fd /\(\<\w\+\>\)\_s*\1

imap ,, <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
imap ，， <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
nmap ,, :!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>
if expand("%:e") == 'cpp'
    exec "unmap ,,"
    echo "已移除"
endif
" "================= 根据文件类型映射按键 =================

" autocmd BufEnter *.cpp,*.md,*.vim,*.py exec ":call MapOrUnmap()"

" func MapOrUnmap()
"     if expand("%:e") == 'cpp'
"          exec "imap ,, <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a"
"          exec "imap ，， <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a"
"          exec "nmap ,, :!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>"
"     elseif expand("%:e") == 'md'
"          exec "imap ,. <Esc>I* <Esc>A"
"
"     else
"          exec "unmap ,,"
"     endif
" endfunc
" if expand('%:t:e') == 'md'
"   imap ,. <Esc>I* <Esc>A
"   nmap ,b <Esc>Bi**<Esc>Ea**<Esc>
"   imap ,b **<Esc>hi**
"   imap ,l <Esc>a**<Esc>i
"   imap jj <Esc>/<++><CR>:nohlsearch<CR>c4l
"   " xdot
"   " imap ,, <Esc>:call PlayAndPause()<CR>
"   " imap ,, :call PlayAndPause()<CR>
"   imap ,, <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
"   imap ，， <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
"   nmap ,, :!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>        
"
" elseif expand('%:t:e') == 'cpp'
"   imap ,, <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
"   imap ，， <Esc>:!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>a
"   nmap ,, :!sh ~/.config/nvim/xdotoolFiles/play.sh<CR><CR>
"   exec "unmap T"
" else
"   exec "unmap T"
" endif

" =================== end =========================

noremap <LEADER><CR> :nohlsearch<CR>
" 分屏移动
noremap gj <C-w>j
noremap gh <C-w>h
noremap gl <C-w>l
noremap gk <C-w>k
" noremap <LEADER>t :e ~/.vimrc<CR>
" 分屏大小
map <up> :res +3<CR>
map <down> :res -3<CR>
map <left> :vertical resize -3<CR>
map <right> :vertical resize +3<CR>

map tt :tabe<CR>
map th :-tabnext<CR>
map tl :+tabnext<CR>

map tx :r !figlet 

map tV :e ~/.config/nvim/init.vim<CR>

" 映射全选+复制 ctrl+a
imap <C-a> <Esc>ggVG
nmap <C-a> ggVG
vmap <C-a> ggG
" map <F12> <nop>

"将选中文本块复制到系统剪贴板
vnoremap <LEADER>y "+y

"将系统剪贴板内容粘贴到vim
" nmap <LEADER>p "+p"


"共享剪贴板  
" set clipboard+=unnamed

" 历史记录数
set history=1000

"自动补全
" :inoremap ( ()<ESC>i
" :inoremap ) <c-r>=ClosePair(')')<CR>
" ":inoremap { {<CR>}<ESC>O
" ":inoremap } <c-r>=ClosePair('}')<CR>
" :inoremap [ []<ESC>i
" :inoremap ] <c-r>=ClosePair(']')<CR>
" ":inoremap " ""<ESC>i
" ":inoremap ' ''<ESC>i
" function! ClosePair(char)
"     if getline('.')[col('.') - 1] == a:char
"         return "\<Right>"
"     else
"         return a:char
"     endif
" endfunction
" "打开文件类型检测, 加了这句才可以用智能补全
" set completeopt=longest,menu


"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" add header comments for .h .c .hpp .cpp .mk .sh new file
" auto call SetTitle func
autocmd BufNewFile *.[ch],*.hpp,*.cpp,Makefile,*.mk,*.sh,*.py exec ":call SetTitle()"
 
func SetTitle()
    if expand("%:e") == 'cpp'
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
Plug 'ryanoasis/vim-devicons'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " enhance devicons


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
" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-jedi', {'do': 'yarn install'}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

"===================
"### auto format ###
"===================

Plug 'Chiel92/vim-autoformat'


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
Plug 'mzlogin/vim-markdown-toc'
Plug 'ferrine/md-img-paste.vim'
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'

"=============
"### theme ###
"=============

" Plug 'crusoexia/vim-monokai'
" Plug 'connorholyday/vim-snazzy'
" Plug 'tyrannicaltoucan/vim-quantum'

"=================
"### Bookmarks ###
"=================

Plug 'kshenoy/vim-signature'

"========
"### compiler ###
"========

Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'


"================
"### debugger ###
"================

Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}

"==============================
"### Other useful utilities ###
"==============================

Plug 'terryma/vim-multiple-cursors'
"Plug 'junegunn/goyo.vim' " distraction free writing mode
Plug 'tpope/vim-surround' " type ysks' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'godlygeek/tabular' " type ;Tabularize /= to align the =
Plug 'gcmt/wildfire.vim' " in Visual mode, type i' to select all text in '', or type i) i] i} ip
Plug 'kien/rainbow_parentheses.vim'
Plug 'junegunn/vim-peekaboo' " 双引号提示

"====================
"### Dependencies ###
"====================

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

" set background=dark
" set termguicolors
" colorscheme quantum
" let g:quantum_black=1
" colorscheme quantum
" let g:quantum_italics=1
" let g:airline_theme='quantum'

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
    nnoremap <silent> T :TagbarOpenAutoClose<CR> " 将tagbar的开关按键设置为 F4


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


" " ######### MarkdownPreview Setting ##########
" let g:mkdp_auto_start = 0
" let g:mkdp_auto_close = 1
" let g:mkdp_refresh_slow = 0
" let g:mkdp_command_for_global = 0
" let g:mkdp_open_to_the_world = 0
" let g:mkdp_open_ip = ''
" let g:mkdp_echo_preview_url = 0
" let g:mkdp_browserfunc = ''
" let g:mkdp_preview_options = {
"             \ 'mkit': {},
"             \ 'katex': {},
"             \ 'uml': {},
"             \ 'maid': {},
"             \ 'disable_sync_scroll': 0,
"             \ 'sync_scroll_type': 'middle',
"             \ 'hide_yaml_meta': 1
"             \ }
" let g:mkdp_markdown_css = ''
" let g:mkdp_highlight_css = ''
" let g:mkdp_port = ''
" let g:mkdp_page_title = '「${name}」'
"


" ######### Markdown img ##########

"设置默认储存文件夹。这里表示储存在当前文档所在文件夹下的'pic'文件夹下，相当于 ./pic/
let g:mdip_imgdir = 'pic' 
"设置默认图片名称。当图片名称没有给出时，使用默认图片名称
let g:mdip_imgname = 'image'
"设置快捷键，个人喜欢 Ctrl+p 的方式，比较直观
autocmd FileType markdown nnoremap <silent> <C-p> :call mdip#MarkdownClipboardImage()<CR>F%i


" ######### Ruby ##########
let g:ruby_host_prog = '/home/wgc/.gem/ruby/2.7.0/bin/neovim-ruby-host'



" ######### coc-setting ##########

let g:coc_global_extensions = [
  \ 'coc-actions',
  \ 'coc-css',
  \ 'coc-diagnostic',
  \ 'coc-explorer',
  \ 'coc-flutter',
  \ 'coc-gitignore',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-python',
  \ 'coc-snippets',
  \ 'coc-sourcekit',
  \ 'coc-syntax',
  \ 'coc-tasks',
  \ 'coc-todolist',
  \ 'coc-translator',
  \ 'coc-tslint-plugin',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-vimlsp',
  \ 'coc-yaml',
  \ 'coc-yank']


  " \ 'coc-stylelint',


" ######### coc-translator ##########

" popup
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
" echo
" nmap <Leader>e <Plug>(coc-translator-e)
" nmap <Leader>e <Plug>(coc-translator-ev)
" " replace
" nmap <Leader>r <Plug>(coc-translator-r)
" nmap <Leader>r <Plug>(coc-translator-rv)



" ######### coc-snippets ##########

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <c-j> <Plug>(coc-snippets-expand-jump)



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
inoremap <silent><expr> <c-h> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

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
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

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

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
"  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" ######### vimspector ##########

nmap <F1> :VimspectorReset<CR>


let g:vimspector_enable_mappings = 'HUMAN'
nmap <F2> :call vimspector#StepInto()<CR>
nmap <F3> :call vimspector#StepOut()<CR>
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




" ######### Async setting ##########

let g:asyncrun_open = 6
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
noremap <silent>sr :AsyncTask file-run<cr>
noremap <silent>sb :AsyncTask make<cr>
noremap <silent>ss :AsyncTask file-build<cr>
" terminal mode: tab/curwin/top/bottom/left/right/quickfix/external
let g:asynctasks_term_pos = 'right'

let g:asynctasks_term_rows = 10    " 设置纵向切割时，高度为 10
let g:asynctasks_term_cols = 80    " 设置横向切割时，宽度为 80

" tab模式终端复用
let g:asynctasks_term_reuse = 1

" 分屏终端焦点不变
" let g:asynctasks_term_focus = 0

" /.vim下全局配置名称
" let g:asynctasks_rtp_config = '~/.config/nvim/tasks.ini'

" 默认全局配置名
" let g:asynctasks_config_name = '.config/nvim/asyncTasks/.tasks.ini'

" 额外默认配置
let g:asynctasks_extra_config = [
    \ '~/.config/nvim/asyncTasks/tasks.ini',
    \ ]

" UI任务选择
"let current_tasks = asynctasks#list("")

" 配置文件不使用模板
let g:asynctasks_template = 0

" ######### Auto Format ##########

noremap <leader>f :Autoformat<CR>
