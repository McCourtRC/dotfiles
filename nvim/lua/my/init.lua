-- NOTE: if things get out of sync,
--   clean up the ~/.local/share/nvim/ folders
----------------------wip----------------------
-- require('extract').setup()

----------------------plugins----------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Plenary
  "nvim-lua/plenary.nvim",

  -- Color Schemes
  { "catppuccin/nvim", name = "catppuccin" },
  -- 'EdenEast/nightfox.nvim',
  -- 'folke/tokyonight.nvim',
  -- 'Mofiqul/dracula.nvim',
  -- { 'Everblush/everblush.nvim', name = 'everblush' },
  -- {'shaunsingh/oxocarbon.nvim', build ='./install.sh'},

  "folke/zen-mode.nvim",

  -- Commentary
  { "numToStr/Comment.nvim",
    opts =  {},
    lazy = false,
  },

  { "kylechui/nvim-surround",
    opts = {},
    event = "VeryLazy",
  },

  {
    'Wansmer/treesj',
    keys = { '<leader>J' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
    end,
  },

  -- Neogit
  { "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },

  { "nvim-tree/nvim-web-devicons",  -- download: https://www.nerdfonts.com/font-downloads
    opts = {
      default = true
    },
  },

  -- Status Line
  { "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
  },

  -- Autopairs
  { "windwp/nvim-autopairs",
    opts = {},
  },

  -- HTML tags
  "windwp/nvim-ts-autotag",

  -- Sneak
  { 'smoka7/hop.nvim',
    version = "*",
  },

  -- File Tree
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({})
    end
  },

  -- Telescope
  "nvim-telescope/telescope-fzy-native.nvim",
  { "nvim-telescope/telescope.nvim",    -- brew install ripgrep
    dependencies = {{"nvim-lua/plenary.nvim"}},
    config = function ()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",     -- npm
            "packer_compiled",  -- lua
            "target",           -- rust
          },
          sorting_strategy="ascending",
          layout_config = {
            prompt_position = "top"
          }
        }
      })
      require("telescope").load_extension("fzy_native")
    end
  },

  -- Harpoon
  { "ThePrimeagen/harpoon",
    dependencies = {{"nvim-lua/plenary.nvim"}}
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/playground",

  -- Completion
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      -- LSP Support
      {"neovim/nvim-lspconfig"},
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},

      -- Autocompletion
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"saadparwaiz1/cmp_luasnip"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-nvim-lua"},

      -- Snippets
      {"L3MON4D3/LuaSnip"},
      {"rafamadriz/friendly-snippets"},
    }
  },

  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- Smooth Scroll
  -- { "karb94/neoscroll.nvim",
  --   config = function ()
  --     require("neoscroll").setup({
  --       mappings = { "<C-d>", "<C-u>" },
  --     })
  --     require("neoscroll.config").set_mappings({
  --       ["<C-d>"] = { "scroll", {"vim.wo.scroll", "true", "50", nil} },
  --       ["<C-u>"] = { "scroll", {"-vim.wo.scroll", "true", "50", nil} }
  --     })
  --
  --   end
  -- },
})

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

----------------------config----------------------
local o  = vim.o
local wo = vim.wo
-- local bo = vim.bo

-- buffer-scoped and window-scoped options
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.scrolloff = 999
o.sidescrolloff = 10
o.completeopt = "menuone,noselect"
o.inccommand = "split"
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.undofile = true
o.equalalways = true

-- window-scoped options
wo.number = true
-- wo.relativenumber = true
wo.wrap = false

-- markdown settings
vim.api.nvim_exec([[
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal linebreak
]], false)


-- Yank Highlight
local yank_highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 50 }) end,
  group = yank_highlight_group,
})

-- Color Schemes
require("catppuccin").setup({
  flavour = "macchiato" -- latte, frappe, macchiato, mocha
})
vim.cmd[[colorscheme catppuccin]]
-- vim.cmd[[colorscheme nightfox]]
-- vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme dracula]]
-- vim.cmd[[colorscheme everblush]]
-- vim.cmd[[colorscheme oxocarbon]]

----------------------mappings----------------------
local map = vim.keymap.set
local options = { noremap = true }

-- Leader
map("n", "<Space>", "", {})
vim.g.mapleader = " "

-- Window Navigation
map("n", "<C-j>", "<C-w>j", options)
map("n", "<C-k>", "<C-w>k", options)
map("n", "<C-h>", "<C-w>h", options)
map("n", "<C-l>", "<C-w>l", options)
map("n", "<C-c>", "<C-w>c", options)

-- Tab Navigation
map("n", "H", "gT", options)
map("n", "L", "gt", options)

-- QuickFix Navigation
map("n", "]q", ":cnext <CR>", options)
map("n", "[q", ":cprev <CR>", options)

-- Yank to clipboard
map({ "n", "v" }, "<leader>y", '"+y', options)

-- Help
map("v", "<leader>h", 'y:vert help <C-r>" <CR>', options)

-- Source File
map("n", "<leader>%", "<cmd>source % <CR>", options)

-- Blank line
map("n", "<leader>o", "mmo<Esc>`m", options)
map("n", "<leader>O", "mmO<Esc>`m", options)

-- Paste Yanked
map({ "n", "v" }, "<leader>p", '"0p', options)
map({ "n", "v" }, "<leader>P", '"0P', options)

-- Find and Replace Selection
map("v", "<leader>s", '"vy:%s/<C-r>v/', options)

-- Move Text
map("v", "J", ":m '>+1 <CR> gv= gv", options)
map("v", "K", ":m '<-2 <CR> gv= gv", options)

-- Smart Join
map("n", "<leader>J", require("treesj").toggle)

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", options)

-- Zen Mode
local zen_mode = require("zen-mode")
map("n", "<leader>z", function() zen_mode.toggle({
  window = {
    width = 80,
  },
}) end, options)

-- Neogit
local neogit = require("neogit")

neogit.setup({
  auto_refresh = false,
})

map("n", "<leader>gg", neogit.open, options)

-- Hop
local hop = require("hop")
map({ "n" }, "s", hop.hint_char1 ,options)
map({ "n" }, "S", require("hop-treesitter").hint_nodes, options)

-- Nvim Tree
local oil = require("oil")
map("n", "<leader>fe", oil.toggle_float, options)
map("n", "<leader>ft", "<cmd>NvimTreeToggle <CR>", options)

-- Telescope
local telescope_builtin = require('telescope.builtin')
map("n", "<leader>f.", telescope_builtin.resume, options)
map("n", "<leader>ff", telescope_builtin.find_files, options)
map("n", "<leader>fo", telescope_builtin.oldfiles, options)
map("n", "<leader>fw", telescope_builtin.grep_string, options)
map("v", "<leader>f", telescope_builtin.grep_string, options)
map("n", "<leader>f/", telescope_builtin.live_grep, options)
map("n", "<leader>/",  telescope_builtin.current_buffer_fuzzy_find, options)
map("n", "<leader>fd", telescope_builtin.diagnostics, options)
map("n", "<leader>fg", telescope_builtin.git_status, options)
map("n", "<leader>fG", telescope_builtin.git_branches, options)
map("n", "<leader>fz", telescope_builtin.git_stash, options)
map("n", "<leader>fb", telescope_builtin.buffers, options)
map("n", "<leader>fh", telescope_builtin.help_tags, options)
map("n", "<leader>fm", telescope_builtin.keymaps, options)
map("n", "<leader>fr", telescope_builtin.lsp_references, options)
map("n", "<leader>f@", telescope_builtin.lsp_document_symbols, options)
map("n", "<leader>fs", telescope_builtin.treesitter, options)
map("n", "<leader>cw", telescope_builtin.spell_suggest, options)

-- Harpoon
local harpoon_mark = require('harpoon.mark')
local harpoon_ui = require('harpoon.ui')
map("n", "<leader>h", harpoon_mark.add_file, options)
map("n", "<leader>H", harpoon_ui.toggle_quick_menu, options)
map("n", "<leader>j", function() harpoon_ui.nav_file(1) end, options)
map("n", "<leader>k", function() harpoon_ui.nav_file(2) end, options)
map("n", "<leader>l", function() harpoon_ui.nav_file(3) end, options)
map("n", "<leader>;", function() harpoon_ui.nav_file(4) end, options)

-- debug
map("n", "<leader>dd", function() require("trouble").open() end)

-- Alternate File
map("n", "<leader>'", ":e # <CR>", options)

-- gitsigns
require("gitsigns").setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local gitsigns_options = { noremap = true, buffer = bufnr }

    -- actions
    map({ "n", "v" }, "<leader>gs", gs.stage_hunk, gitsigns_options)
    map("n", "<leader>gS", gs.stage_buffer, gitsigns_options)
    map("n", "<leader>gu", gs.undo_stage_hunk, gitsigns_options)
    map("n", "<leader>gU", gs.reset_buffer_index, gitsigns_options)
    map({ "n", "v" }, "<leader>gr", gs.reset_hunk, gitsigns_options)
    map("n", "<leader>gR", gs.reset_buffer, gitsigns_options)
    map("n", "<leader>gp", gs.preview_hunk, gitsigns_options)
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, gitsigns_options)
    map("n", "<leader>gd", gs.diffthis)
    map("n", "<leader>gD", function() gs.diffthis("~") end, gitsigns_options)

    -- text objects
    ---- navigation
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
    map({ "n", "x", "o" }, "]g", next_hunk_repeat)
    map({ "n", "x", "o" }, "<leader>gj", next_hunk_repeat)
    map({ "n", "x", "o" }, "[g", prev_hunk_repeat)
    map({ "n", "x", "o" }, "<leader>gk", prev_hunk_repeat)

    ---- selction
    map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", gitsigns_options)
  end
}

----------------------lsp----------------------
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.set_preferences({
  set_lsp_keymaps = false,
})

lsp.ensure_installed({
  "cssls",
  "eslint",
  "graphql",
  "html",
  "jsonls",
  "rust_analyzer",
  -- "sumneko_lua",
  -- "tailwindcss",
  "tsserver",
  "yamlls",
})

-- Completion
local cmp = require("cmp")

lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
})

lsp.on_attach(function(client, bufnr)
  local lsp_options = { noremap = true, silent = true, buffer = bufnr }

  map("n", "gd", vim.lsp.buf.definition, lsp_options)
  map("n", "gD", vim.lsp.buf.declaration, lsp_options)
  map("n", "gr", vim.lsp.buf.references, lsp_options)
  map("n", "gI", vim.lsp.buf.implementation, lsp_options)

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  local goto_next, goto_prev = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
  map("n", "]d",         goto_next, lsp_options)
  map("n", "<leader>dj", goto_next, lsp_options)
  map("n", "[d",         goto_prev, lsp_options)
  map("n", "<leader>dk", goto_prev, lsp_options)
  map("n", "<leader>dl", vim.diagnostic.open_float, lsp_options)

  map("n", "<leader>ca", vim.lsp.buf.code_action, lsp_options)
  map("n", "<leader>rn", vim.lsp.buf.rename, lsp_options)
  map("n", "<leader>=",  function () vim.lsp.buf.format({ async = true }) end, lsp_options)

  map("n", "K", vim.lsp.buf.hover, lsp_options)
  map("n", "<leader>D", vim.lsp.buf.type_definition, lsp_options)
end)

lsp.nvim_workspace()
lsp.setup()

----------------------treesitter----------------------
require"nvim-treesitter.configs".setup {
  -- ensure_installed = { "" },
  auto_install = true,
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
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
      init_selection = "<leader>v",
      node_incremental = "+",
      node_decremental = "-",
    }
  },
  autotag = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = function (args)
        return string.find(args.query_string, "outer")
      end,
      keymaps = {
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ir"] = "@parameter.inner",
        ["ar"] = "@parameter.outer",
        ["ac"] = "@comment.outer",

        -- custom
        ["iv"] = "@variable.inner",
        ["av"] = "@variable.outer",
        ["it"] = "@type.inner",
        ["at"] = "@type.outer",
        ["a;"] = "@pair",
        ["i;"] = "@pair",
        ["ak"] = "@key",
        ["ik"] = "@key",
        ["al"] = "@value",
        ["il"] = "@value",
        ["ii"] = "@item.inner",
        ["ai"] = "@item.outer",
        ["ih"] = "@html.inner",
        ["ah"] = "@html.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>xr"] = "@parameter.inner",
        ["<leader>xf"] = "@function.outer",
        ["<leader>xv"] = "@variable.outer",
        ["<leader>x;"] = "@pair",
        ["<leader>xi"] = "@item.inner",
        ["<leader>xh"] = "@html.outer",
      },
      swap_previous = {
        ["<leader>xR"] = "@parameter.inner",
        ["<leader>xF"] = "@function.outer",
        ["<leader>xV"] = "@variable.outer",
        ["<leader>x:"] = "@pair",
        ["<leader>xI"] = "@item.inner",
        ["<leader>xH"] = "@html.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]r"] = "@parameter.inner",
        ["]t"] = "@type.inner",
        ["]f"] = "@function.outer",
        ["]c"] = "@comment.outer",
        ["]v"] = "@variable.outer",
        ["];"] = "@pair",
        ["]k"] = "@key",
        ["]l"] = "@value",
        ["]i"] = "@item.inner",
        ["]h"] = "@html.start",
      },
      goto_next_end = {
        ["]R"] = "@parameter.inner",
        ["]T"] = "@type.inner",
        ["]F"] = "@function.outer",
        ["]C"] = "@comment.outer",
        ["]V"] = "@variable.outer",
        ["]:"] = "@pair",
        ["]K"] = "@key",
        ["]L"] = "@value",
        ["]I"] = "@item.inner",
        ["]H"] = "@html.end",
      },
      goto_previous_start = {
        ["[r"] = "@parameter.inner",
        ["[t"] = "@type.inner",
        ["[f"] = "@function.outer",
        ["[c"] = "@comment.outer",
        ["[v"] = "@variable.outer",
        ["[;"] = "@pair",
        ["[k"] = "@key",
        ["[l"] = "@value",
        ["[i"] = "@item.inner",
        ["[h"] = "@html.start",
      },
      goto_previous_end = {
        ["[R"] = "@parameter.inner",
        ["[T"] = "@type.inner",
        ["[F"] = "@function.outer",
        ["[C"] = "@comment.outer",
        ["[V"] = "@variable.outer",
        ["[:"] = "@pair",
        ["[K"] = "@key",
        ["[L"] = "@value",
        ["[I"] = "@item.inner",
        ["[H"] = "@html.end",
      },
    },
  },
}

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

----------------------snippets----------------------
local luasnip = require("luasnip")

luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

map({ "i", "s" }, "<C-j>", function()
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    end
  end,
  { silent = true }
)

map({ "i", "s" }, "<C-k>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end,
  { silent = true }
)

map({ "i", "s" }, "<C-l>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end
)

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

-- luasnip.add_snippets("all", {
-- })

