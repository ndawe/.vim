set nocompatible
filetype off 
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Don't mess up local directories
set dir=~/.vimcrud
set backupdir=~/.vimcrud

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"" Reduce autocomplete
set complete=.,w,b

" Enable syntax highlighting
syntax on

" Highlight last searched term
"set cursorline
"set cursorcolumn
set hlsearch
set hidden
set autowrite
set expandtab
set nowrap
set number
set visualbell
set noerrorbells
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*.root,*.pyc,*.png,*.pdf,*.ps
set ignorecase
set smartcase
set scrolloff=3
set novisualbell

" Enable filetype detection
filetype plugin indent on

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set autoindent		" always set autoindenting on

set smartindent
set tabstop=4
set shiftwidth=4

" Makefile sanity
autocmd BufEnter ?akefile* set noet ts=8 sw=8

" reStructuredText
autocmd BufEnter *.rst set et ts=3 sw=3

" Majority vote on tabs vs spaces
function Kees_settabs()
    if len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^\\t"')) > len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^ "'))
        set noet ts=8 sw=8
    endif
endfunction
autocmd BufReadPost * call Kees_settabs()

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" Delete trailing whitespace before saving in tex, cpp and python
autocmd BufWritePre *.cxx,*.cpp,*.icc,*.cc,*.h,*.py,*.tex :%s/\s\+$//e

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif
augroup END

" NERD Tree settings
map <silent> <C-P> <ESC>:NERDTreeToggle<CR>
let NERDTreeIgnore=['CVS', 'pyc$', '\.root$', 'pdf$', 'png$', '@Batch', 'xml.bak$', 'xml.fragment$']
let NERDTreeWinSize=61
let NERDTreeWinPos=0
let NERDTreeChDirMode=2 "always set root as cwd
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
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %{fugitive#statusline()} %y\ [%{&encoding}:%{&fileformat}]\ \ "
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

func! WordProcessorMode() 
  setlocal formatoptions=1 
  setlocal noexpandtab 
  map j gj 
  map k gk 
  setlocal smartindent 
  setlocal spell spelllang=en_us 
  setlocal wrap 
  setlocal linebreak 
  setlocal syntax=none 
endfu 
com! WP call WordProcessorMode()

if (v:version >= 700)
    highlight SpellBad      ctermfg=Red         term=Reverse        guisp=Red       gui=undercurl   ctermbg=White
    highlight SpellCap      ctermfg=Green       term=Reverse        guisp=Green     gui=undercurl   ctermbg=White
    highlight SpellLocal    ctermfg=Cyan        term=Underline      guisp=Cyan      gui=undercurl   ctermbg=White
    highlight SpellRare     ctermfg=Magenta     term=underline      guisp=Magenta   gui=undercurl   ctermbg=White
endif " version 7+ 

" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%80v.\+/

if exists("&colorcolumn")
    set colorcolumn=80
endif

function! s:Underline(chars)
  let chars = empty(a:chars) ? '-' : a:chars
  let nr_columns = virtcol('$') - 1
  let uline = repeat(chars, (nr_columns / len(chars)) + 1)
  put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call s:Underline(<q-args>)

" http://stackoverflow.com/questions/2360249/vim-automatically-removes-indentation-on-python-comments
inoremap # X<BS>#
