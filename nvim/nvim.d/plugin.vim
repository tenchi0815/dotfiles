"" Plugins
if ! empty(globpath(&rtp, 'autoload/plug.vim'))
    call plug#begin()
    " hybrid.vim
    Plug 'https://github.com/w0ng/vim-hybrid.git'
    " fzf.vim
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " The default plugin directory will be as follows:
    "   - Vim (Linux/macOS): '~/.vim/plugged'
    "   - Vim (Windows): '~/vimfiles/plugged'
    "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
    " You can specify a custom plugin directory by passing it as the argument
    "   - e.g. `call plug#begin('~/.vim/plugged')`
    "   - Avoid using standard Vim directory names like 'plugin'

    " Make sure you use single quotes

    " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    " 
    " Any valid git URL is allowed
    " Plug 'https://github.com/junegunn/vim-github-dashboard.git'

    " Multiple Plug commands can be written in a single line using | separators
    " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

    " On-demand loading
    " Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
    " Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

    " Using a non-default branch
    " Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

    " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
    " Plug 'fatih/vim-go', { 'tag': '*' }

    " Plugin options
    " Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

    " Plugin outside ~/.vim/plugged with post-update hook
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    " Unmanaged plugin (manually installed and updated)
    " Plug '~/my-prototype-plugin'

    " Initialize plugin system
    " - Automatically executes `filetype plugin indent on` and `syntax enable`.
    Plug 'easymotion/vim-easymotion'
    " You can revert the settings after the call like so:
    "   filetype indent off   " Disable file-type-specific indentation
    "   syntax off            " Disable syntax highlighting

    " Assign <space>to <Leader>
    let mapleader = '<space>'

    " vim-easymotion
    " <Leader>f{char} to move to {char}
    map  <Leader>f <Plug>(easymotion-bd-f)
    nmap <Leader>f <Plug>(easymotion-overwin-f)

    " s{char}{char} to move to {char}{char}
    " nmap s <Plug>(easymotion-overwin-f2)

    " Move to line
    " map <Leader>L <Plug>(easymotion-bd-jk)
    " nmap <Leader>L <Plug>(easymotion-overwin-line)

    " Move to word
    map  <Leader>w <Plug>(easymotion-bd-w)
    nmap <Leader>w <Plug>(easymotion-overwin-w)

    " vim-easymotion
    " <Leader>f{char} to move to {char}
    " map  f <Plug>(easymotion-bd-f)
    " nmap f <Plug>(easymotion-overwin-f)

    " s{char}{char} to move to {char}{char}
    " nmap s <Plug>(easymotion-overwin-f2)

    " Move to line
    " map L <Plug>(easymotion-bd-jk)
    " nmap L <Plug>(easymotion-overwin-line)

    " Move to word
    " map  w <Plug>(easymotion-bd-w)
    " nmap w <Plug>(easymotion-overwin-w)

    " Gif config
    " map l <plug>(easymotion-lineforward)
    " map j <plug>(easymotion-j)
    " map k <plug>(easymotion-k)
    " map h <plug>(easymotion-linebackward)

    " let g:easymotion_startofline = 0 " keep cursor column when jk motion" gif config
    map <leader>l <plug>(easymotion-lineforward)
    map <leader>j <plug>(easymotion-j)
    map <leader>k <plug>(easymotion-k)
    map <leader>h <plug>(easymotion-linebackward)

    let g:easymotion_startofline = 0 " keep cursor column when jk motion

    let g:easymotion_smartcase = 1

    let g:easymotion_use_migemo = 1
    "
    " Mapping selecting mappings
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    "######### markdown-preview ###############################################################################
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

    " set to 1, nvim will open the preview window after entering the Markdown buffer
    " default: 0
    let g:mkdp_auto_start = 0

    " set to 1, the nvim will auto close current preview window when changing
    " from Markdown buffer to another buffer
    " default: 1
    let g:mkdp_auto_close = 1

    " set to 1, Vim will refresh Markdown when saving the buffer or
    " when leaving insert mode. Default 0 is auto-refresh Markdown as you edit or
    " move the cursor
    " default: 0
    let g:mkdp_refresh_slow = 0

    " set to 1, the MarkdownPreview command can be used for all files,
    " by default it can be use in Markdown files only
    " default: 0
    let g:mkdp_command_for_global = 0

    " set to 1, the preview server is available to others in your network.
    " By default, the server listens on localhost (127.0.0.1)
    " default: 0
    let g:mkdp_open_to_the_world = 0

    " use custom IP to open preview page.
    " Useful when you work in remote Vim and preview on local browser.
    " For more details see: https://github.com/iamcco/markdown-preview.nvim/pull/9
    " default empty
    let g:mkdp_open_ip = ''

    " specify browser to open preview page
    " for path with space
    " valid: `/path/with\ space/xxx`
    " invalid: `/path/with\\ space/xxx`
    " default: ''
    let g:mkdp_browser = ''

    " set to 1, echo preview page URL in command line when opening preview page
    " default is 0
    let g:mkdp_echo_preview_url = 0

    " a custom Vim function name to open preview page
    " this function will receive URL as param
    " default is empty
    let g:mkdp_browserfunc = ''

    " options for Markdown rendering
    " mkit: markdown-it options for rendering
    " katex: KaTeX options for math
    " uml: markdown-it-plantuml options
    " maid: mermaid options
    " disable_sync_scroll: whether to disable sync scroll, default 0
    " sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
    "   middle: means the cursor position is always at the middle of the preview page
    "   top: means the Vim top viewport always shows up at the top of the preview page
    "   relative: means the cursor position is always at relative positon of the preview page
    " hide_yaml_meta: whether to hide YAML metadata, default is 1
    " sequence_diagrams: js-sequence-diagrams options
    " content_editable: if enable content editable for preview page, default: v:false
    " disable_filename: if disable filename header for preview page, default: 0
    let g:mkdp_preview_options = {
        \ 'mkit': {},
        \ 'katex': {},
        \ 'uml': {},
        \ 'maid': {},
        \ 'disable_sync_scroll': 0,
        \ 'sync_scroll_type': 'middle',
        \ 'hide_yaml_meta': 1,
        \ 'sequence_diagrams': {},
        \ 'flowchart_diagrams': {},
        \ 'content_editable': v:false,
        \ 'disable_filename': 0,
        \ 'toc': {}
        \ }

    " use a custom Markdown style. Must be an absolute path
    " like '/Users/username/markdown.css' or expand('~/markdown.css')
    let g:mkdp_markdown_css = ''

    " use a custom highlight style. Must be an absolute path
    " like '/Users/username/highlight.css' or expand('~/highlight.css')
    let g:mkdp_highlight_css = ''

    " use a custom port to start server or empty for random
    let g:mkdp_port = ''

    " preview page title
    " ${name} will be replace with the file name
    let g:mkdp_page_title = '「${name}」'

    " use a custom location for images
    " let g:mkdp_images_path = /home/tenchi/.markdown_images

    " recognized filetypes
    " these filetypes will have MarkdownPreview... commands
    let g:mkdp_filetypes = ['markdown']

    " set default theme (dark or light)
    " By default the theme is defined according to the preferences of the system
    let g:mkdp_theme = 'dark'

    " combine preview window
    " default: 0
    " if enable it will reuse previous opened preview window when you preview markdown file.
    " ensure to set let g:mkdp_auto_close = 0 if you have enable this option
    let g:mkdp_combine_preview = 0

    " auto refetch combine preview contents when change markdown buffer
    " only when g:mkdp_combine_preview is 1
    let g:mkdp_combine_preview_auto_refresh = 1

    " example
    nmap <C-s> <Plug>MarkdownPreview
    nmap <M-s> <Plug>MarkdownPreviewStop
    nmap <C-p> <Plug>MarkdownPreviewToggle

    "let g:denops_server_addr = '127.0.0.1:32123'
    let g:denops#deno = expand('~/.deno/bin/deno')
    Plug 'vim-denops/denops.vim'
    Plug 'vim-denops/denops-helloworld.vim'

    Plug 'Shougo/ddc.vim'
    Plug 'Shougo/ddc-source-around'
    Plug 'Shougo/ddc-filter-matcher_head'
    Plug 'Shougo/ddc-filter-sorter_rank'
    Plug 'Shougo/ddc-source-nextword'
    Plug 'Shougo/ddc-around'
    Plug 'Shougo/ddc-ui-native'
    "Plug 'Shougo/ddc-source-lsp'
    "
    "Plug 'neovim/nvim-lspconfig'
    "
    Plug 'preservim/nerdtree'

    call plug#end()

    call ddc#custom#patch_global('ui', 'native')
    call ddc#custom#patch_global('sources', ['around', 'nextword'])
    call ddc#custom#patch_global('sourceOptions', {
          \ 'around': {'mark': 'A'},
          \ '_': {
          \   'matchers': ['matcher_head'],
          \   'sorters': ['sorter_rank']},
          \ })
    call ddc#custom#patch_global('sourceOptions', #{
    \   nextword: #{
    \     mark: 'nextword',
    \     minAutoCompleteLength: 3,
    \     isVolatile: v:true,
    \ }})

    "call ddc#custom#patch_global('sources', ['lsp'])
    "call ddc#custom#patch_global('sourceOptions', #{
    "      \   lsp: #{
    "      \     mark: 'lsp',
    "      \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
    "      \   },
    "      \ })

    "call ddc#custom#patch_global('sourceParams', #{
    "      \   lsp: #{
    "      \     snippetEngine: denops#callback#register({
    "      \           body -> vsnip#anonymous(body)
    "      \     }),
    "      \     enableResolveItem: v:true,
    "      \     enableAdditionalTextEdit: v:true,
    "      \   }
    "      \ })

    call ddc#enable()

endif
