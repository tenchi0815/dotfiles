"------------------------------------------------------------------------------
let g:vim_home = expand('<sfile>:h')
let g:rc_dir = expand(g:vim_home . '/nvim.d')

" function to load rc files
function s:source_rc(rc_file)
    "let rc_file = expand(g:rc_dir . '/' . a:rc_file_name)
    if filereadable(a:rc_file)
        execute 'source' a:rc_file
    endif
endfunction

function s:list_rc(rc_dir)
    " load all .vim files in rc_dir
    for rc_file in split(glob(a:rc_dir . '/*.vim'), '\n')
        call s:source_rc(rc_file)
    endfor
endfunction

call s:list_rc(rc_dir)

" " OS specific configurations
"------------------------------------------------------------------------------
if has('wsl')
    let g:env_dir = expand(g:rc_dir . '/env/wsl')
    call s:list_rc(env_dir)
endif

" " Common settings
"------------------------------------------------------------------------------
"" Detect newline code
set fileformats=unix,dos,mac
" Show line numbers
set nu
" Enable sytax highlighting
syntax enable
" Highlight extra space
autocmd BufWinEnter <buffer> match Error /\s\+$/
autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
autocmd InsertLeave <buffer> match Error /\s\+$/
autocmd BufWinLeave <buffer> call clearmatches()
" Tab stop and shift width
set ts=4 sw=4
set expandtab

" Window settings
set splitbelow
set splitright
" Status line setting
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{&fenc!=''?&fenc:&enc}\ %{&ff}\ %y\ \ %P
" hi statusline ctermfg=99 ctermbg=white

" NORMAL mode
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

" INSERT mode
inoremap <silent> jj <ESC>

"" File-type-dependent settings
" set noexpandtab when opening tsv (by MS Copilot)
augroup tsv_files
    autocmd!
    autocmd BufRead,BufNewFile *.tsv setlocal noexpandtab
augroup END

" Clipboard integration
set clipboard+=unnamedplus

" " Aesthetic
"------------------------------------------------------------------------------
set termguicolors
" colorschemeより前に記述.
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none

" Set 'hybrid' colorscheme. Ignore the error if it does not exist.
set background=dark
silent! colorscheme hybrid
" highlight LineNr ctermfg=darkgrey
" Cursor line settings
set cursorline
set cursorcolumn

" netrw config
let g:netrw_liststyle=1
let g:netrw_liststyle=1
