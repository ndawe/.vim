set nocompatible
filetype off 

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

" File is large from 10mb
let g:LARGEFILESIZE = 1024 * 1024 * 10
let g:FILESIZE=getfsize(expand('%:p'))

" Pathogen setup
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Don't mess up local directories
set dir=~/.vimcrud
set backupdir=~/.vimcrud

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Reduce autocomplete
set complete=.,w,b

" Enable syntax highlighting
syntax on

"set cursorline
"set cursorcolum
set hidden
set autowrite
set visualbell
set noerrorbells
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*.root,*.pyc,*.png,*.pdf,*.ps
set ignorecase
set smartcase
set scrolloff=3
set novisualbell
set nojoinspaces

" Enable filetype detection
filetype plugin indent on

set history=700
set undolevels=700
set ruler		" Show the cursor position all the time
set showcmd		" Display incomplete commands
set incsearch	" Do incremental searching

set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab
set smarttab
set autoindent
set smartindent

" except in Makefiles...
"autocmd BufEnter ?akefile* set noet ts=8 sw=8

" Special case for reStructuredText indentation
autocmd BufEnter *.rst set et ts=3 sw=3

" Majority vote on indentation (tabs vs spaces, 4 spaces vs 2 spaces)
" for those times when you need to edit someone else's code
function! Determine_Indentation()
    if g:FILESIZE > g:LARGEFILESIZE
        return
    endif
    let n_tabs = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^\\t"'))
    let n_spaces = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^ "'))
    if n_tabs > n_spaces
        set tabstop=4 shiftwidth=4 noexpandtab
    else
        let n_2_spaces = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^  \\S"'))
        let n_4_spaces = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^    \\S"'))
        if n_2_spaces > n_4_spaces
            set tabstop=2 shiftwidth=2 softtabstop=2
        endif
    endif
endfunction
autocmd BufReadPost * call Determine_Indentation()

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" Delete trailing whitespace
autocmd BufWritePre *.sh,*.cxx,*.cpp,*.icc,*.cc,*.h,*.py,*.pyx,*.rst,*.md,*.bib,Makefile,Dockerfile :%s/\s\+$//e

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" NERD Tree settings
map <silent> <C-P> <ESC>:NERDTreeToggle<CR>
let NERDTreeIgnore=['CVS', 'pyc$', '\.root$', 'pdf$', 'png$', '@Batch', 'xml.bak$', 'xml.fragment$']
let NERDTreeWinSize=61
let NERDTreeWinPos=0
let NERDTreeChDirMode=2 " Always set root as cwd
let NERDTreeChristmasTree = 1

let g:syntastic_auto_loc_list=1
set statusline=%t\ %m%r[%04l,%02c]
set statusline+=\ \ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set laststatus=2
set noerrorbells
set vb t_vb=
set nospell
set tw=80

" Don't use plaintex, but tex
let g:tex_flavor='latex'

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    if &expandtab == "0"
        let indentation = "tabs"
    else
        let indentation = "%{&shiftwidth}-space"
    endif
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %{fugitive#statusline()} %y\ [".indentation.":%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction

"au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
"au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
    if a:mode == 'i'
        hi StatColor guibg=orange ctermbg=lightred
    elseif a:mode == 'r'
        hi StatColor guibg=#e454ba ctermbg=magenta
    elseif a:mode == 'v'
        hi StatColor guibg=#e454ba ctermbg=magenta
    else
        hi StatColor guibg=red ctermbg=red
    endif
endfunction 

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

map \c" "+yi"
map \c' "+yi'
map \cW "+yiW
map \cw "+yiw

command! CondenseBlanks :%s/\n\{3,}/\r\r/e
let $uw='/afs/hep.wisc.edu/home/efriis'

function! WordProcessorMode() 
    setlocal formatoptions=1 
    setlocal noexpandtab 
    map j gj 
    map k gk 
    setlocal smartindent 
    setlocal spell spelllang=en_au 
    setlocal wrap 
    setlocal linebreak 
    "setlocal syntax=none 
endfunction
com! WP call WordProcessorMode()

if (v:version >= 700)
    highlight SpellBad      ctermfg=Red         term=Reverse        guisp=Red       gui=undercurl   ctermbg=White
    highlight SpellCap      ctermfg=Green       term=Reverse        guisp=Green     gui=undercurl   ctermbg=White
    highlight SpellLocal    ctermfg=Cyan        term=Underline      guisp=Cyan      gui=undercurl   ctermbg=White
    highlight SpellRare     ctermfg=Magenta     term=underline      guisp=Magenta   gui=undercurl   ctermbg=White
endif " version 7+ 

" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
"autocmd BufEnter *.py,*.cpp,*.cxx,*.rst,*.tex highlight OverLength ctermbg=lightred ctermfg=white guibg=#FFD9D9
"autocmd BufEnter *.py,*.cpp,*.cxx,*.rst,*.tex match OverLength /\%80v.\+/
autocmd BufEnter *.py,*.cpp,*.cxx,*.rst,*.tex
            \ if exists("&colorcolumn") |
                \ set colorcolumn=80 |
            \ endif
"augroup END

"if version >= 703
    "set colorcolumn=80
    "highlight ColorColumn ctermbg=233
"endif

function! s:Underline(chars)
    let chars = empty(a:chars) ? '-' : a:chars
    let nr_columns = virtcol('$') - 1
    let uline = repeat(chars, (nr_columns / len(chars)) + 1)
    put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call s:Underline(<q-args>)

" http://stackoverflow.com/questions/2360249/vim-automatically-removes-indentation-on-python-comments
inoremap # X<BS>#

" https://github.com/mbrochh/vim-as-a-python-ide/blob/master/.vimrc
" http://www.youtube.com/watch?feature=endscreen&NR=1&v=YhqsjUUHj6g
"set mouse=a
set bs=2
" Autromatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
autocmd! bufwritepost vimrc source %

" Better copy & paste
set pastetoggle=<F2>
set clipboard=unnamed

" Remove highlight of your last search
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Quicksave
noremap <C-Z> :update<CR>
inoremap <C-Z> <C-C>:update<CR>
vnoremap <C-Z> <C-O>:update<CR>

" Rebind <Leader> key
let mapleader = ","

" Quickexit
noremap <Leader>e :quit<CR>  " quit current window
noremap <Leader>E :qa!<CR>   " quit all windows

" Bind keys to move around windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
map <Leader>b <esc>:tabnew<CR>

" Map sort function to a key
vnoremap <Leader>s :sort<CR>

" Easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" Easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing

" Auto linebreak in text
"au BufEnter *.txt *.tex setl tx ts=4 sw=4 fo+=n2a

" Disable folding
set nofoldenable

au BufRead,BufNewFile *.tex,*.sty set fileformat=unix

function! LargeFileOptions()
    " no syntax highlighting etc
    set eventignore+=FileType
    " save memory when other file is viewed
    setlocal bufhidden=unload
    " is read-only (write with :w new_filename)
    setlocal buftype=nowrite
    " no undo possible
    setlocal undolevels=-1
    " display message
    autocmd VimEnter *  echo "The file is larger than " . (g:LARGEFILESIZE / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

augroup LargeFileTest 
    autocmd BufReadPre * if g:FILESIZE > g:LARGEFILESIZE || g:FILESIZE == -2 | call LargeFileOptions() | endif
augroup END
