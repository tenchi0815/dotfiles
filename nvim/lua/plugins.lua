return {
  --- hybrid colorscheme
  { "w0ng/vim-hybrid" },

  --- fzf and fzf.vim
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },

  --- easymotion
  {
    "easymotion/vim-easymotion",
    lazy = false,
    keys = {
      { "<Leader>f", "<plug>(easymotion-bd-f)", mode = { "n", "x", "o" }, desc="EasyMotion move to {char}" },
      { "<Leader>f", "<plug>(easymotion-overwin-f)", desc="EasyMotion move to {char}"},
      { "<Leader>w", "<plug>(easymotion-bd-w)", mode = { "n", "x", "o" }, desc="EasyMotion move to word" },
      { "<Leader>w", "<plug>(easymotion-overwin-w)", desc="EasyMotion move to word" },
      { "<leader>l", "<plug>(easymotion-lineforward)", mode = { "n", "x", "o" }, desc="EasyMotion line forward" },
      { "<leader>j", "<plug>(easymotion-j)", mode = { "n", "x", "o" }, desc="EasyMotion line down" },
      { "<leader>k", "<plug>(easymotion-k)", mode = { "n", "x", "o" }, desc="EasyMotion line up" },
      { "<leader>h", "<plug>(easymotion-linebackward)", mode = { "n", "x", "o" }, desc="EasyMotion line backword" },
    },

    init = function()
      vim.g.easymotion_startofline = 0
      vim.g.easymotion_smartcase = 1
      vim.g.easymotion_use_migemo = 1
      vim.g.mapleader = " "
    end,
  },

  --- markdown-preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    lazy = true,
    keys = {
      { "<C-s>", "<cmd>MarkdownPreview<cr>", desc = "Preview markdown file" },
      { "<M-s>", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop preview" },
      { "<C-p>", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle preview" },
    },
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false ,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      -- vim.g.mkdp_images_path = '/home/tenchi/.markdown_images'
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_combine_preview = 0
      vim.g.mkdp_combine_preview_auto_refresh = 1
    end,
  },

  --- denops and related
  { "vim-denops/denops.vim" },
  { "vim-denops/denops-helloworld.vim" },

  --- ddc and related
  {
    "Shougo/ddc.vim",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/ddc-source-around",
      "Shougo/ddc-filter-matcher_head",
      "Shougo/ddc-filter-sorter_rank",
      "Shougo/ddc-source-nextword",
      "Shougo/ddc-ui-native",
      "Shougo/ddc-source-lsp",
    },
    event = "InsertEnter",
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.fn["ddc#custom#patch_global"]("ui", "native")
      vim.fn["ddc#custom#patch_global"]("autoCompleteEvents", {
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
      })
      vim.fn["ddc#custom#patch_global"]("sources", {"around", "nextword", "lsp"})
      vim.fn["ddc#custom#patch_global"]("sourceOptions", {
        _  = {
          matchers = { "matcher_head" },
          sorters = { "sorter_rank" },
        },
        around = { mark = "A" },
        nextword = {
          mark = "nextword",
          minAutoCompleteLength = 3,
          isVolatile = true,
        },
        lsp = {
          mark = "lsp",
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]]
        },
      })

      -- Key mappings
      vim.fn["ddc#custom#patch_global"]("sourceParams", {
        lsp = {
          snippetEngine = vim.fn["denops#callback#register"](function(body)
            vim.fn["vsnip#anonymous"](body)
          end),
          enableResolveItem = true,
          enableAdditionalTextEdit = true,
        },
        copilot = {
          copilot = "vim",
        },
      })
      -- Enable completion menu
      vim.fn["ddc#enable"]()
    end,
  },

--  { "Shougo/ddc-source-around" },
--  { "Shougo/ddc-filter-matcher_head" },
--  { "Shougo/ddc-filter-sorter_rank" },
--  { "Shougo/ddc-source-nextword" },
--  { "Shougo/ddc-around" },
--  { "Shougo/ddc-ui-native" },
--  { "Shougo/ddc-source-lsp" },
--  { "Shougo/ddc-source-copilot" },

  { "matsui54/denops-popup-preview.vim" },
  { "matsui54/denops-signature_help" },

  --- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      local map = vim.keymap.set
      map("i", "<leader><Tab>", "copilot#Accept('<CR>')", {noremap = true, silent = true, expr=true, replace_keycodes = false })
    end,
  },

  --- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      { "github/copilot.vim" },
    },
    build = "make tiktoken",
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    opts = {
       model = "gpt-5.4",
      -- See Configuration section for options
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      -- Auto-command to customize chat buffer behavior
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { resources = { "buffer" }, })
          end
        end,
        desc = "CopilotChat - Quick chat",
        mode = "n",
      },
      {
        "<leader>cco",
        function()
          require("CopilotChat").open({ resources = { "buffer" }, })
        end,
        desc = "CopilotChat - Open",
        mode = "n",
      },
    },
  },
  -- nerdtree
  --{
    --  "preservim/nerdtree",
    --  keys = {
      --    { "<Leader>n", ":NERDTreeFocus<CR>", mode = "n" },
      --    { "<Leader><C-n>", ":NERDTree<CR>", mode = "n" },
      --    { "<Leader><C-t>", ":NERDTreeToggle<CR>", mode = "n" },
      --    { "<Leader><C-f>", ":NERDTreeFind<CR>", mode = "n" },
      --  },
      --  cmd = { "NERDTreeToggle", "NERDTree", "NERDTreeFocus", "NERDTreeFind" },
      --  config = function()
        --    vim.api.nvim_create_autocmd('BufEnter', {
          --      pattern = '*',
          --      callback = function()
            --        if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree() then
            --          vim.api.nvim_feedkeys(":quit\n:\b", 'n', false)
            --        end
            --      end,
            --    })
            --  end,
            --},
  -- hicolcode.vim
  {
    "MeF0504/hicolcode.vim",
    lazy = true,
    init = function()
      vim.g.hicolcode_auto_enable = 1 -- If set 1, color codes are highlighted automatically. (default: 0)
      -- vim.g.hicolcode_max_idx = 100 -- The max number of highlight indexes. Bigger is better to avoid duplication, but maybe the processing becomes heavy. (default: 100)
    end,
  },
}
