-- NOTE: if things get out of sync,
--   clean up the ~/.local/share/nvim/ folders
----------------------wip----------------------
-- require('extract').setup()

-- Utils
local map = vim.keymap.set
local options = { noremap = true }

-- Leader
map("n", "<Space>", "", {})
vim.g.mapleader = " "

----------------------plugins----------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- automatically check for plugin updates
  checker = { enabled = true },

  -- Plenary
  "nvim-lua/plenary.nvim",

  -- Color Schemes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato" -- latte, frappe, macchiato, mocha
    },
  },
  -- 'EdenEast/nightfox.nvim',
  -- 'folke/tokyonight.nvim',
  -- 'Mofiqul/dracula.nvim',
  -- { 'Everblush/everblush.nvim', name = 'everblush' },
  -- {'shaunsingh/oxocarbon.nvim', build ='./install.sh'},

  { "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 80,
      },
    },
    keys = {
      { "<leader>z", function() require("zen-mode").toggle() end, desc = "Zen Mode Toggle" },
    },
  },

  -- Commentary
  { "numToStr/Comment.nvim",
    opts =  {},
    lazy = false,
  },

  { "kylechui/nvim-surround",
    opts = {},
    event = "VeryLazy",
  },

  { 'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
    },
    keys = {
      { "<leader>J", function() require("treesj").toggle() end, desc = "Smart Join" },
    },
  },

  -- Neogit
  { "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    opts = {
      auto_refresh = false,
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Git UI" }
    }
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = {
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
    },
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

  -- HTML tags
  "windwp/nvim-ts-autotag",

  -- Sneak
  { 'smoka7/hop.nvim',
    version = "*",
    opts = {},
    keys = {
      { "s", function() require("hop").hint_char1() end, "Hop Character" },
      { "S", function() require("hop-treesitter").hint_nodes() end, desc = "Hop Treesitter" },
    },
  },

  -- File Tree
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>fe", function() require("oil").toggle_float() end, desc = "File Editor" }
    },
  },

  -- Telescope
  "nvim-telescope/telescope-fzy-native.nvim",
  { "nvim-telescope/telescope.nvim",    -- brew install ripgrep
    branch = '0.1.x',
    dependencies = {{"nvim-lua/plenary.nvim"}},
    config = function ()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",     -- npm
            "packer_compiled",  -- lua
            "target",           -- rust
          },
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top"
          },
        },
        extensions = {
          fzy = {},
        },
      })
      require("telescope").load_extension("fzy_native")
    end,
    keys = {
      { "<leader>f.", function() require("telescope.builtin").resume() end, desc = "Find Reopen" },
      { "<leader>fa", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Find Recent Files" },
      { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find Word" },
      { "<leader>fW", function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") }) end, desc = "Find WORD" },
      { "<leader>f", mode = "v",  function() require("telescope.builtin").grep_string() end, desc = "Find Word Selection" },
      { "<leader>f/", function() require("telescope.builtin").live_grep() end, desc = "Search Directory" },
      { "<leader>/",  function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search Buffer" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find Diagnostics" },
      { "<leader>fg", function() require("telescope.builtin").git_status() end, desc = "Find Git Status" },
      { "<leader>fG", function() require("telescope.builtin").git_branches() end, desc = "Find Git Branches" },
      { "<leader>fz", function() require("telescope.builtin").git_stash() end, desc = "Find Git Stashes" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Search Help" },
      { "<leader>fm", function() require("telescope.builtin").keymaps() end, desc = "Find Keymaps" },
      { "<leader>fr", function() require("telescope.builtin").lsp_references() end, desc = "Find LSP References" },
      { "<leader>f@", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Find Buffer Symbols" },
      { "<leader>fs", function() require("telescope.builtin").treesitter() end, desc = "Find Treesitter Nodes" },
      { "<leader>cw", function() require("telescope.builtin").spell_suggest() end, desc = "Change Word Spelling" },
    }
  },

  -- Harpoon
  { "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {{"nvim-lua/plenary.nvim"}},
    keys = {
      { "<leader>h", function() require("harpoon"):list():add() end, desc = "Harpoon File" },
      { "<leader>H", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
      { "<leader>j", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>k", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>l", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>;", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  { "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      max_lines = 5,
    },
  },

  -- Loading Status
  { "j-hui/fidget.nvim", opts = {} },

  -- Cloak
  { "laytan/cloak.nvim", opts = {} },


  --     -- Snippets
  { 'L3MON4D3/LuaSnip', version = 'v2.*'},
  { 'rafamadriz/friendly-snippets' },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>dd", function() require("trouble").open() end, desc = "Trouble Toggle"},
    },
  },

  -- Database
  { "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "sqlite" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Copilot
  "github/copilot.vim",
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    keys = {
      { "<leader>cp", function() require("CopilotChat").toggle() end, desc = "CopilotChat Toggle"},
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
})

----------------------corl------------------------
vim.filetype.add({
  extension = {
    corl = "corl"
  }
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.corl = {
  install_info = {
    url = vim.fn.expand("~/repos/bitlikethis/corlang/tree-sitter-corl"), -- expand ~ to absolute path
    files = {"src/parser.c"},
  },
  filetype = "corl",
}

-- Corl queries are synced manually using /sync-queries command
-- This is because nvim-treesitter doesn't respect runtimepath for queries


----------------------config----------------------

-- buffer-scoped and window-scoped options
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 999
vim.o.sidescrolloff = 10
vim.o.completeopt = "menuone,noselect,popup"
vim.o.inccommand = "split"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.undofile = true
vim.o.equalalways = true
vim.o.cursorline = true
vim.o.winborder = "rounded"


vim.opt.conceallevel = 2

-- window-scoped options
vim.wo.number = true
-- vim.wo.relativenumber = true
vim.wo.wrap = false

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
vim.cmd[[colorscheme catppuccin]]
-- vim.cmd[[colorscheme nightfox]]
-- vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme dracula]]
-- vim.cmd[[colorscheme everblush]]
-- vim.cmd[[colorscheme oxocarbon]]

----------------------mappings----------------------
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

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
local quickfix_next, quickfix_prev = ts_repeat_move.make_repeatable_move_pair(function() vim.cmd("cnext") end, function() vim.cmd("cprev") end)
map("n", "]q", quickfix_next, { noremap = true, silent = true })
map("n", "<leader>qj", quickfix_next, { noremap = true, silent = true })
map("n", "[q", quickfix_prev, { noremap = true, silent = true })
map("n", "<leader>qk", quickfix_prev, { noremap = true, silent = true })

-- Open URL
-- map("n", "gx", "<cmd>!open <cword><CR>", options)

-- Yank to clipboard
map({ "n", "v" }, "<leader>y", '"+y', options)

-- Help
map("v", "<leader>h", 'y:vert help <C-r>" <CR>', options)

-- Source File
map("n", "<leader>%", "<cmd>source % <CR>", options)

-- Paste Yanked
map({ "n", "v" }, "<leader>p", '"0p', options)
map({ "n", "v" }, "<leader>P", '"0P', options)

-- Find and Replace Selection
map("v", "<leader>s", '"vy:%s/<C-r>v/', options)

-- Move Text
map("v", "J", ":m '>+1 <CR> gv= gv", options)
map("v", "K", ":m '<-2 <CR> gv= gv", options)

map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy Toggle" })

-- Inspect Tree
map("n", "<leader>i", "<cmd>InspectTree <cr>", { desc = "Inspect Tree" })

-- Alternate File
map("n", "<leader>'", ":e # <CR>", options)

----------------------lsp----------------------

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    -- autocomplete
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, {
          autotrigger = true,
          convert = function(item)
            return { abbr = item.label:gsub('%b()', '') }
          end,
        })
      end

    -- lsp mappings
    local lsp_options = { noremap = true, silent = true, buffer = ev.buf }
    map("n", "<leader>=",  function () vim.lsp.buf.format({ async = true }) end, lsp_options)
  end,
})

-- servers
vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "eslint",
  "rust_analyzer",
  "gdscript",
  "clangd",
  "gleam",
  "gopls",
})

-- diagnostics
vim.diagnostic.config({
  virtual_text = { current_line = true },
  -- virtual_lines = true
})
local goto_next, goto_prev = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
map("n", "<leader>dj", goto_next, options)
map("n", "<leader>dk", goto_prev, options)
map("n", "<leader>dl", vim.diagnostic.open_float, options)

-- Completion
-- local cmp = require("cmp")

-- cmp.setup({
--   sources = {
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "vim-dadbod-completion" },
--     { name = "path" },
--     { name = "buffer", keyword_length = 100 },
--   }, {
--     { name = "buffer" },
--     { name = "vim-dadbod-completion" },
--   },
--   mapping = cmp.mapping.preset.insert({
--     ["<C-Space>"] = cmp.mapping.complete(),
--     ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--     ["<C-f>"] = cmp.mapping.scroll_docs(4),
--     ["<C-e>"] = cmp.mapping.abort(),
--   }),
--   snippet = {
--     expand = function(args)
--       require("luasnip").lsp_expand(args.body)
--     end,
--   },
-- })

----------------------treesitter----------------------
require("nvim-treesitter.configs").setup({
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
        ["]F"] = "@call.outer",
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
        ["[F"] = "@call.outer",
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
})

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

