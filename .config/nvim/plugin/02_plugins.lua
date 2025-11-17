--- Vim Packages
vim.cmd("packadd cfilter")

-- Bootstrap Paq
local function clone_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
  end
  vim.cmd.packadd("paq-nvim")
end
clone_paq()

-- Packages
local packages = {
  'savq/paq-nvim',

  --consider lazygit
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',

  "saghen/blink.cmp",

  {'nvim-mini/mini.nvim', branch = 'stable'},

  'stevearc/oil.nvim',
  'stevearc/quicker.nvim',
  'kevinhwang91/nvim-bqf',
  'mbbill/undotree',
  'chentoast/marks.nvim',

  '3rd/image.nvim',
  'MeanderingProgrammer/render-markdown.nvim',
  'chomosuke/typst-preview.nvim',

  'folke/flash.nvim',

  'cbochs/grapple.nvim',

  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  "nvim-treesitter/nvim-treesitter-context",

  'mason-org/mason.nvim',
  'neovim/nvim-lspconfig',
  'mason-org/mason-lspconfig.nvim',
  'folke/lazydev.nvim',

  -- 'stevearc/conform.nvim',

  'rafamadriz/friendly-snippets',

  'sainnhe/gruvbox-material',
  'sainnhe/sonokai',
  'marko-cerovac/material.nvim',
}
require 'paq' (packages)

---------------------------------------------------------
--- Setups
---------------------------------------------------------
-- LSP for NVIM Config
require 'lazydev'.setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "LazyVim", words = { "LazyVim" } },
    { path = "snacks.nvim", words = { "Snacks" } },
    { path = "lazy.nvim", words = { "LazyVim" } },
  },
})

-- Proper Markdown, Typst
require 'image'.setup()
require 'typst-preview'.setup()

require 'marks'.setup()

-- File Marks
require 'grapple'.setup({icons = false})


require('mini.basics').setup({
options = {
  extra_ui = true
},
mappings = {
  windows = true,
},
})
require('mini.indentscope').setup()
require('mini.bufremove').setup()

require 'mini.visits'.setup()
local mini_misc = require 'mini.misc'
mini_misc.setup()
mini_misc.setup_restore_cursor()
-- mini_misc.setup_termbg_sync()
--
require 'blink-cmp'.setup({
  cmdline = {
    enabled = true
  },
})

-- Setup like vim surround
require('mini.surround').setup({
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',

    -- Add this only if you don't want to use extended mappings
    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
})

require('mini.statusline').setup()

local miniclue = require('mini.clue')
miniclue.setup({
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({ submode_resize = true }),
    miniclue.gen_clues.z(),
  },
})

require('mini.pick').setup()
vim.ui.select = MiniPick.ui_select

require('mini.extra').setup()
-- require('mini.completion').setup()
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    -- Load custom file with global snippets first (adjust for Windows)
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})
require('mini.icons').setup()
require('mini.icons').tweak_lsp_kind()

require('mason').setup()
require('mason-lspconfig').setup()

require("oil").setup({
  keymaps = {
      ["gh"] = { "actions.toggle_hidden", mode = "n" },
  },
})
require('quicker').setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "markdown", "markdown_inline", "python" },
  auto_install = true,
  ignore_install = {},
  highlight = {enable = true,},
  textobjects = {
    enable = true,
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,

      goto_next_start = {
	["]f"] = "@function.outer",
	["]c"] = "@class.outer",
	["]r"] = "@return.outer",
      },
      goto_next_end = {
	["]F"] = "@function.outer",
	["]C"] = "@class.outer",
	["]R"] = "@return.outer",
      },
      goto_previous_start = {
	["[f"] = "@function.outer",
	["[c"] = "@class.outer",
	["[r"] = "@return.outer",
      },
      goto_previous_end = {
	["[F"] = "@function.outer",
	["[C"] = "@class.outer",
	["[R"] = "@return.outer",
      },
    }
  },
}

vim.cmd[[
hi TreesitterContextBottom gui=underline guisp=Grey
hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
]]
