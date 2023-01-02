-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Better winw navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("n", "<leader>e", vim.cmd.RnvimrToggle)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- x to void
keymap("n", "x", '"_x', opts)
keymap("v", "x", '"_x', opts)
keymap("n", "X", '"_dd', opts)

-- y to Clipboard
keymap({"n", "v"}, "<leader>y", '"+y')

-- Search and Replace
keymap('n', '<C-f>', ':%s/', { noremap = true })

-- Save when updated
keymap('n', '<C-s>', ':up<CR>', { noremap = true })

-- Normal mode quick actions
keymap("n", "<CR>", 'mzo<ESC>`z', opts)
keymap("n", "<BS>", 'hx', opts)
-- Insert single character
keymap("n", "<leader>i", '"=nr2char(getchar())<CR>P', opts)

-- Cursoe stays in middle of screen after moving
keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move selected lines
keymap("n", "<A-j>", "v:move '>+1<CR>gv=gv<ESC>", opts)
keymap("n", "<A-k>", "v:move '<-2<CR>gv=gv<ESC>", opts)
keymap({"v", "x"}, "<A-j>", ":move '>+1<CR>gv=gv", opts)
keymap({"v", "x"}, "<A-k>", ":move '<-2<CR>gv=gv", opts)

-- Plugins --

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)


-- Undotree
keymap('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })

-- LSP

-- Change Symbol
keymap("n", "cs", vim.lsp.buf.rename, opts)

-- Trouble Diagnostice
keymap("n", "<leader>d", ":TroubleToggle document_diagnostics<CR>", opts)
