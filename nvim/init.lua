-- load plugins
require("config.lazy")

-- function to load rc files
-- OS specific configurations
-- Confirm that 'zenhan' is executable
if vim.fn.executable("zenhan") == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      -- zenhan 0 でIMEをオフにする
      vim.fn.system("zenhan 0")
    end,
  })
end

-- Common settings
vim.opt.fileformats = { 'unix', 'dos', 'mac' }
vim.opt.number = true
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- Highlight extra space
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    vim.fn.matchadd('Error', '\\s\\+$')
  end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    vim.fn.matchadd('Error', '\\s\\+\\%#\\@<!$')
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    vim.fn.matchadd('Error', '\\s\\+$')
  end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*',
  callback = function()
    vim.cmd('call clearmatches()')
  end,
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.zone',
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Window settings
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Status line setting
vim.opt.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%) %{&fenc!=''?&fenc:&enc} %{&ff} %y  %P"

-- NORMAL mode remaps
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<Down>', 'gj')
vim.keymap.set('n', '<Up>', 'gk')
vim.g.mapleader = " "

-- INSERT mode remap
vim.keymap.set('i', 'jj', '<ESC>', { silent = true })

-- File-type-dependent settings
vim.api.nvim_create_augroup('tsv_files', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'tsv_files',
  pattern = '*.tsv',
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Clipboard integration
vim.opt.clipboard:append('unnamedplus')

-- Aesthetic
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.cmd('highlight Normal ctermbg=none')
    vim.cmd('highlight LineNr ctermbg=none')
  end,
})

vim.opt.background = 'dark'
pcall(vim.cmd, 'colorscheme hybrid')
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_preview = 1
vim.g.netrw_keepdir = 0

vim.g.NetrwIsOpen = 0
function _G.ToggleNetrw()
  if vim.g.NetrwIsOpen == 1 then
    for i = vim.fn.bufnr('$'), 1, -1 do
      if vim.fn.getbufvar(i, '&filetype') == 'netrw' then
        vim.cmd('silent bwipeout ' .. i)
      end
    end
    vim.g.NetrwIsOpen = 0
  else
    vim.g.NetrwIsOpen = 1
    vim.cmd('silent Vex')
  end
end

vim.keymap.set('n', '==', ':lua ToggleNetrw()<CR>', { silent = true })

-- LSP
vim.lsp.config("*", {
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
})
vim.lsp.enable("ts_ls")

-- Set diagnostic config
vim.diagnostic.config({
    -- virtual_lines = true,
     virtual_text = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

--vim.keymap.set("n", "<leader>ccq", function()
--  local input = vim.fn.input("Quick Chat: ")
--  if input ~= "" then
--    require("CopilotChat").ask(input, { resources = { "buffer" } })
--  end
--end, { desc = "CopilotChat - Quick chat" })
