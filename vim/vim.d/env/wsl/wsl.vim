" " For windows environment
"
" IME integration
if executable('zenhan')
    autocmd InsertLeave * :call system('zenhan 0')
    autocmd CmdlineLeave * :call system('zenhan 0')
endif

" Clipboard integration
if executable('win32yank.exe')
    set clipboard=unnamed
    let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': 'win32yank.exe -i',
    \      '*': 'win32yank.exe -i',
    \    },
    \   'paste': {
    \      '+': 'win32yank.exe -o --lf',
    \      '*': 'win32yank.exe -o --lf',
    \   },
    \   'cache_enabled': 1,
    \ }
endif


