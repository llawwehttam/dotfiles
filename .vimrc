syntax enable
set number
set background=dark
set tabstop=2
set softtabstop=4
set shiftwidth=2
set expandtab
set copyindent
set autoindent
set showmatch
set ignorecase
set smarttab
set hlsearch
set incsearch
set t_Co=256
filetype on

let g:solarized_termtrans=1
colorscheme zenburn

map <F2> :NERDTreeToggle<CR>
set showtabline=2
map <C><j> :tabn<cr>
map <C><k> :tabp<cr>

:set guitablabel=%t

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

call pathogen#infect()
"StripTrailingWhitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"Autocommands
if has("autocmd")
" Show trailing whitepace and spaces before a tab:
    autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
endif

"Use the same symbols as TextMate for tabstops and EOL's
set listchars=tab:▸\ ,eol:¬

" Shortcuts

"Hidden Chars
nmap <leader>l :set list!<CR>

"autoindentation
nmap <leader>a :set autoindent!<CR>

"Run StripTrailingWhiteSpace Function
nmap <leader>s :call <SID>StripTrailingWhitespaces()<CR>

"Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set laststatus=2

"Toggle numbers
nmap <leader>n :set number!<CR>
