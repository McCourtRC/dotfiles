----------------------wip----------------------
-- require('extract').setup()

----------------------plugins----------------------
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'

  -- lua docs
  use 'milisims/nvim-luaref'

  -- Color Schemes
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'EdenEast/nightfox.nvim'
  use 'folke/tokyonight.nvim'
  use 'Mofiqul/dracula.nvim'

  -- Commentary
  use { 'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {}
    end
  }

  -- TPope
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'

  -- Plenary
  use 'nvim-lua/plenary.nvim'

  -- Git signs
  use { 'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  -- Status Line
  use { 'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  use { 'kyazdani42/nvim-web-devicons',  -- download: https://www.nerdfonts.com/font-downloads
    config = function()
        require('nvim-web-devicons').setup {
          default = true
        }
    end
  }

  -- Autopairs
  use { 'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup{} end
  }

  -- HTML tags
  use 'windwp/nvim-ts-autotag'

  -- Sneak
  use { 'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
    end
  }

  -- File Tree
  use { 'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup()
    end
  }

  -- Telescope
  use { 'nvim-telescope/telescope.nvim',    -- brew install ripgrep
    requires = {{'nvim-lua/plenary.nvim'}},
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Harpoon
  use { 'ThePrimeagen/harpoon',
    requires = {{'nvim-lua/plenary.nvim'}}
  }

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'

  -- Completion
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('impatient')

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      'node_modules',     -- npm
      'packer_compiled',  -- lua
      'target',           -- rust
    },
    sorting_strategy='ascending',
    layout_config = {
      prompt_position = 'top'
    }
  }
}
require('telescope').load_extension('fzf')

----------------------config----------------------
local o  = vim.o
local wo = vim.wo
-- local bo = vim.bo

-- global options
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.scrolloff = 999
o.sidescrolloff = 10
o.completeopt = 'menuone,noselect'
o.inccommand = 'split'

-- window-local options
wo.number = true
-- wo.relativenumber = true
wo.wrap = false

-- buffer-local options
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.undofile = true

-- Yank Highlight
local yank_highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank({ timeout = 50 }) end,
  group = yank_highlight_group,
})

-- Color Schemes
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]
-- vim.cmd[[colorscheme nightfox]]
-- vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme dracula]]

----------------------mappings----------------------
local map = vim.keymap.set
local options = { noremap = true }

-- Leader
map('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- Window Navigation
map('n', '<C-j>', '<C-w>j', options)
map('n', '<C-k>', '<C-w>k', options)
map('n', '<C-h>', '<C-w>h', options)
map('n', '<C-l>', '<C-w>l', options)
map('n', '<C-c>', '<C-w>c', options)

-- Tab Navigation
map('n', 'H', 'gT', options)
map('n', 'L', 'gt', options)

-- QuickFix Navigation
map('n', ']q', ':cnext <CR>', options)
map('n', '[q', ':cprev <CR>', options)

-- Jump to last insert
map('n', 'g.', 'gi', options)

-- Yank to clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', options)

-- Help
map('v', '<leader>h', 'y:vert help <C-r>" <CR>', options)

-- Source File
map('n', '<leader>%', '<cmd>source % <CR>', options)

-- Blank line
map('n', '<leader>o', 'mmo<Esc>`m', options)
map('n', '<leader>O', 'mmO<Esc>`m', options)

-- Paste Yanked
map({ 'n', 'v' }, '<leader>p', '"0p', options)
map({ 'n', 'v' }, '<leader>P', '"0P', options)

-- Find and Replace Selection
map('v', '<leader>s', '"vy:%s/<C-r>v//gc<left><left><left>', options)

-- Move Text
map('v', 'J', ":m '>+1 <CR> gv= gv", options)
map('v', 'K', ":m '<-2 <CR> gv= gv", options)

-- Alternate File
map('n', "<leader>'", ':e # <CR>', options)

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', options)

-- Hop
local hop = require('hop')
map({ 'n', 'v' }, 's', hop.hint_char1 ,options)
map({ 'n', 'v' }, 'S', hop.hint_lines, options)

-- Nvim Tree
map('n', '<leader>fe', '<cmd>NvimTreeToggle <CR>', options)

-- Telescope
local telescope_builtin = require('telescope.builtin')
map('n', '<leader>ff', telescope_builtin.find_files, options)
map('n', '<leader>f/', telescope_builtin.live_grep, options)
map('n', '<leader>/',  telescope_builtin.current_buffer_fuzzy_find, options)
map('n', '<leader>fd', telescope_builtin.diagnostics, options)
map('n', '<leader>fg', telescope_builtin.git_status, options)
map('n', '<leader>fG', telescope_builtin.git_branches, options)
map('n', '<leader>fz', telescope_builtin.git_stash, options)
map('n', '<leader>fb', telescope_builtin.buffers, options)
map('n', '<leader>fh', telescope_builtin.help_tags, options)
map('n', '<leader>fm', telescope_builtin.keymaps, options)
map('n', '<leader>fr', telescope_builtin.lsp_references, options)
map('n', '<leader>f@', telescope_builtin.lsp_document_symbols, options)
map('n', '<leader>fts', telescope_builtin.treesitter, options)

-- Harpoon
local harpoon_mark = require('harpoon.mark')
local harpoon_ui = require('harpoon.ui')
local harpoon_term = require('harpoon.term')
map('n', '<leader>h', harpoon_mark.add_file, options)
map('n', '<leader>H', harpoon_ui.toggle_quick_menu, options)
map('n', '<leader>j', function() harpoon_ui.nav_file(1) end, options)
map('n', '<leader>k', function() harpoon_ui.nav_file(2) end, options)
map('n', '<leader>l', function() harpoon_ui.nav_file(3) end, options)
map('n', '<leader>;', function() harpoon_ui.nav_file(4) end, options)
map('n', '<leader>t', function() harpoon_term.gotoTerminal(0) end, options)

-- Lua Snip
map({ 'i', 's' }, '<Tab>',   function() require("luasnip").jump(1) end, options)
map({ 'i', 's' }, '<S-Tab>', function() require("luasnip").jump(-1) end, options)

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local gitsigns_options = { noremap = true, buffer = bufnr }

    local function git_next_hunk()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end

    local function git_prev_hunk()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end

    -- navigation
    map('n', ']g', git_next_hunk, { expr = true })
    map('n', '<leader>gj', git_next_hunk, { expr = true })

    map('n', '[g', git_prev_hunk, { expr = true })
    map('n', '<leader>gk', git_prev_hunk, { expr = true })

    -- actions
    map({ 'n', 'v' }, '<leader>gs', gs.stage_hunk, gitsigns_options)
    map('n', '<leader>gS', gs.stage_buffer, gitsigns_options)
    map('n', '<leader>gu', gs.undo_stage_hunk, gitsigns_options)
    map('n', '<leader>gU', gs.reset_buffer_index, gitsigns_options)
    map({ 'n', 'v' }, '<leader>gr', gs.reset_hunk, gitsigns_options)
    map('n', '<leader>gR', gs.reset_buffer, gitsigns_options)
    map('n', '<leader>gp', gs.preview_hunk, gitsigns_options)
    map('n', '<leader>gb', function() gs.blame_line { full = true } end, gitsigns_options)

    -- text objects
    map({ 'o', 'x' }, 'ig', ':<C-U>Gitsigns select_hunk<CR>', gitsigns_options)
  end
}

----------------------lsp----------------------
local lsp_on_attach = function(client, bufnr)
  local lsp_options = { noremap = true, silent = true, buffer = bufnr }

  map('n', 'gD', vim.lsp.buf.declaration, lsp_options)
  map('n', 'gd', vim.lsp.buf.definition, lsp_options)
  map('n', 'gr', vim.lsp.buf.references, lsp_options)
  map('n', 'gi', vim.lsp.buf.implementation, lsp_options)

  map('n', ']d',         vim.diagnostic.goto_next, lsp_options)
  map('n', '<leader>dj', vim.diagnostic.goto_next, lsp_options)
  map('n', '[d',         vim.diagnostic.goto_prev, lsp_options)
  map('n', '<leader>dk', vim.diagnostic.goto_prev, lsp_options)

  map('n', '<leader>ca', vim.lsp.buf.code_action, lsp_options)
  map('n', '<leader>rn', vim.lsp.buf.rename, lsp_options)
  map('n', '<leader>=',  vim.lsp.buf.formatting, lsp_options)

  map('n', 'K', vim.lsp.buf.hover, lsp_options)
  map('n', '<leader>D', vim.lsp.buf.type_definition, lsp_options)

  -- disable tsserver formatting in favor of prettier
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require('lspconfig')

--Enable (broadcasting) snippet capability for completion
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
  'tsserver',      -- npm install --location=global typescript typescript-language-server
  'html',          -- npm install --location=global vscode-langservers-extracted
  'cssls',         -- npm install --location=global vscode-langservers-extracted
  'tailwindcss',   -- npm install --location=global @tailwindcss/language-server
  'svelte',        -- npm install --location=global svelte-language-server
  'graphql',       -- npm install --location=global graphql-language-service-cli
  'jsonls',        -- npm install --location=global vscode-langservers-extracted
  'yamlls',        -- npm install --location=global yaml-language-server
  'eslint',        -- npm install --location=global vscode-langservers-extracted
  'rust_analyzer', -- brew install rust-analyzer
  'prismals',      -- npm install --location=global @prisma/language-server
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- formatting with null-ls
local null_ls = require('null-ls')
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
  }
}

-- brew install lua-language-server
require'lspconfig'.sumneko_lua.setup {
  on_attach = lsp_on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- "nvim-ts-autotag" setting to prevent bad diagnostics in {j,t}sx
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = {
      spacing = 5,
      severity_limit = 'Warning',
    },
    update_in_insert = true,
  }
)

----------------------completion----------------------
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  },
  {
    {name = 'buffer', keyword_length = 5}
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', keyword_length = 5 }
  }
})

-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline', keyword_length = 5 }
--   })
-- })

----------------------treesitter----------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { 'phpdoc' }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<leader>v',
      node_incremental = '+',
      node_decremental = '-',
    }
  },
  autotag = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ir"] = "@parameter.inner",
      },
    },
  },
}

----------------------snippets----------------------
local snip = luasnip.snippet
local s = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- require("luasnip.loaders.from_vscode").lazy_load() -- opts can be ommited
require("luasnip").config.setup({ store_selection_keys = "<Tab>" })

-- luasnip.add_snippets('all', {
-- })

