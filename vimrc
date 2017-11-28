" vim/gvim configuration
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number      " see https://github.com/myusuf3/numbers.vim#vim-74 (required by the numbers plugin)

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=n "but only in normal mode, replace with 'a' for all modes
  set ttymouse=xterm
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("gui_running")
    set guifont=Source\ Code\ Pro\ for\ Powerline\ Semi-Light\ 10
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

" Vundle (see /usr/share/vundle/vimrc.sample)
filetype off

call vundle#rc()

Plugin 'Valloric/YouCompleteMe'
"Plugin 'fatih/vim-go'
"Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'myusuf3/numbers.vim'
Plugin 'Auto-Pairs'
Plugin 'moll/vim-node'
Plugin 'scrooloose/nerdtree'
Plugin 'Syntastic'
Plugin 'mtscout6/syntastic-local-eslint.vim'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'crusoexia/vim-javascript-lib'
Plugin 'ternjs/tern_for_vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'terryma/vim-multiple-cursors'

" Themes
Plugin 'altercation/vim-colors-solarized'
Plugin 'christophermca/meta5'
Plugin 'jacoborus/tender.vim'
Plugin 'glortho/feral-vim'

filetype plugin indent on


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"if !exists(":DiffOrig")
"  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
"		  \ | wincmd p | diffthis
"endif

" The following fixes mappings like <A-j> (move up-down)
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set ttimeout ttimeoutlen=5

" general settings
set t_Co=256
set scrolloff=2 "make sure the cursor is 2 lines away from the edge
"set nowrap
set showmatch
set matchtime=5
set hidden
set splitright
set noswapfile
set nobackup

" Control character highlighting
" Visible after :set list
set list
"set listchars=tab:»\ ,eol:↵
set listchars=tab:»\ ,trail:.,extends:#,space:·,eol:¬
set tabstop=2
set shiftwidth=2
set expandtab
set ignorecase
set smartcase
set wildignore=*.swp,*.bak,*.pyc,*.class,*~

"set autochdir
set completeopt=menu,menuone

"Colorscheme
set background=dark
"colorscheme solarized
" from here: https://github.com/jpo/vim-railscasts-theme
" colorscheme railscasts
colorscheme tender

" <Leader> remap
let mapleader = ","

" My Remaps
"nnoremap <F2> :Unite file <CR>
nnoremap <F5> :GundoToggle<CR>
"nnoremap <F3> :NumbersToggle<CR>
nnoremap <silent> <M-k> :m-2<CR>
nnoremap <silent> <M-j> :m+<CR>
vnoremap <silent> <M-k> :m '<-2<CR>gv=gv
vnoremap <silent> <M-j> :m '>+1<CR>gv=gv
" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv 
nmap <M-o> o<Esc>

" Move through splits
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l

" Swap splits
map <silent>,H <C-w>H
map <silent>,J <C-w>J
map <silent>,K <C-w>K
map <silent>,L <C-w>L

" open splits
nnoremap <leader>w <C-w>v
nnoremap <leader>q <C-w>q

" My hard mode:
noremap <Down> <NOP>
noremap <Up> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Other remaps
noremap <F10> :set paste!<CR>
nmap <silent> <leader>/ :nohlsearch<CR>

" Lets you sudo from within vim
cmap w!! w !sudo tee % >/dev/null

" paste from clipboard
" + - selection clipboard
" * - ctrl+c/v clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "*P
" copy to clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "*Y

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1

autocmd FileType javascript setlocal conceallevel=1

let g:javascript_conceal_function               = "ƒ"
let g:javascript_conceal_arrow_function         = "⇒"

" NERDTree
let NERDTreeQuitOnOpen=0
map <F2> :NERDTreeToggle<CR>
map <F3> :NERDTreeFind<CR>

" For switching buffers:
map ,b :b

"Define filetype for rss and atom
autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml

" Add < and > to matchpair for these types aswell
autocmd FileType html,htmldjango,xml setlocal matchpairs+=<:>

"YCM
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_previous_completion=['<C-p>']
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ucm_use_ultisnips_completer = 1
let g:EclimCompletionMethod = 'omnifunc'
noremap ,d :YcmCompleter GoTo<CR>

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

"Jedi for argument completion only
" {
"    let g:jedi#auto_vim_configuration = 0
"    let g:jedi#popup_on_dot = 0
"    let g:jedi#popup_select_first = 0
"    let g:jedi#completions_enabled = 0
"    let g:jedi#completions_command = ""
"    let g:jedi#show_call_signatures = "1"
"
"    let g:jedi#goto_assignments_command = "<leader>pa"
"    let g:jedi#goto_definitions_command = "<leader>pd"
"    let g:jedi#documentation_command = "<leader>pk"
"    let g:jedi#usages_command = "<leader>pu"
"    let g:jedi#rename_command = "<leader>pr"
" }

"UltiSnips
"let g:UltiSnipsExpandTrigger = "<C-j>"
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"Conque
"nnoremap <F4> :Conque

" htmldjango-omnicomplete stuff
"au FileType htmldjango set omnifunc=htmldjangocomplete#CompleteDjango
"au FileType python.django set omnifunc=pythoncomplete#Complete
"let g:htmldjangocomplete_html_flavour = 'html401s'
"au FileType htmldjango inoremap {% {% %}<left><left><left>
"au FileType htmldjango inoremap {{ {{ }}<left><left><left>

" Try autoinserting brackets for other types as well:
""inoremap {<CR> {<CR>}<ESC>O
"iinoremap ( ()<left>
"iinoremap [ []<left>
"iinoremap " ""<left>
"iinoremap ' ''<left>

" log4j
au! BufRead,BufNewFile catalina.out,*.out,*.out.*,*.log,*.log.* setf log

" Make vim watch for changes in vimrc file and reload
augroup reload_vimrc
    au!
    au BufWritePost $MYVIMRC so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" vim-powerline:
set laststatus=2   " Always show the statusline
"set encoding=utf-8 " Necessary to show Unicode glyphs
let g:Powerline_symbols='unicode'

" airline settings
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_buffers = 1
"let g:airline#extensions#bufferline#overwrite_variables = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme = 'tender'

" tagbar
"autocmd FileType * nested :call tagbar#autoopen(0)  " open tagbar on supported filetypes
nmap <F8> :TagbarToggle<CR>

" CommandT
"let g:CommandTMatchWindowAtTop = 1
"let g:CommandTMaxHeight = 20
" If backspace does not work in CommandT command line - change xfce4
" backspace settings to ASCII DEL

" Take care of django files
"autocmd BufNewFile,BufRead *.html call s:FThtmldjango()
"autocmd BufNewFile,BufRead *.py call s:FTpydjango()
"func! s:FThtmldjango()
"    let n = 1
"    while n < 30 && n < line("$")
"        if getline(n) =~ '.*{%.*'
"            set ft=htmldjango
"            return
"        endif
"        let n = n + 1
"    endwhile
"    set ft=html
"endfunc
"
"func! s:FTpydjango()
"    let n = 1
"    while n < 30 && n < line("$")
"        if getline(n) =~ '.*django.*'
"            set ft=python.django
"            return
"        endif
"        let n = n + 1
"    endwhile
"    set ft=python
"endfunc

" vim-jsdoc
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1


" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers=['eslint']

" tern
let g:tern_show_argument_hints='on_hold'
let g:tern_map_keys=1

" ctrlp
let g:ctrlp_custom_ignore = 'node_modules'

" others
" save work on focus lost (silent to not complain if the buffer is untitled)
" nested because "any other autocommands bound to `BufWrite` work as normal"
au FocusLost * nested silent! wa

" easier buffer switching
" from http://vim.wikia.com/wiki/VimTip686 -> Switching by number
nnoremap <leader>b :buffers<CR>:buffer<Space>

" vim-gitgutter
nmap <Leader>hv <Plug>GitGutterPreviewHunk
