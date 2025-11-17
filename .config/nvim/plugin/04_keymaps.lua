---------------------------------------------------------
--- Keymaps
---------------------------------------------------------

---------------------------------------------------------
------- General
---------------------------------------------------------
vim.api.nvim_create_user_command("Grep", vim.cmd('silent grep'), {})

vim.keymap.set( "n", "<leader>so", ":w<CR>:so ~/.config/nvim/init.lua<CR>", {desc = "Source init.lua"})

vim.keymap.set( "t", "<Esc><Esc>", "<C-\\><C-n>", {desc = "Exit Terminal Mode with <Esc><Esc>"})

vim.cmd[[cabbrev & w]]
vim.cmd[[cabbrev E Oil]]

vim.keymap.set( "n", "<leader>Lf", vim.lsp.buf.format, {desc = "Format current buffer"})

---------------------------------------------------------
------- Plugin-Specific
---------------------------------------------------------

--- Oil
vim.keymap.set("n", "<leader>e", ':Oil<CR>', { desc = "Explorer", })
vim.keymap.set("n", "<leader>E", ':Oil %:h<CR>', { desc = "Explorer at File"})
vim.keymap.set("n", "-", ':Oil %:h<CR>', { desc = "Explorer at File"})

--- Mini Pick Files
vim.keymap.set("n", "<C-p>", ':Pick files<CR>', { desc = "Pick Files", })

--- Mini Pick live_grep
vim.keymap.set("n", "<leader>fg", ':Pick grep_live<CR>', { desc = "Pick Files", })
--- Mini Pick Files
vim.keymap.set("n", "<leader>ff", ':Pick files<CR>', { desc = "Pick Files", })
--- Mini Pick Oldfiles
vim.keymap.set("n", "<leader>fo", ':Pick oldfiles<CR>', { desc = "Pick Oldfiles", })
--- Mini Pick Explorer
vim.keymap.set("n", "<leader>fe", ':Pick explorer<CR>', { desc = "Pick Explorer", })
--- Mini Pick Visits
vim.keymap.set("n", "<leader>fv", ':Pick visit_paths<CR>', { desc = "Pick Visits", })

--- MiniBufremove
vim.keymap.set("n", "<C-q>", function()
  MiniBufremove.delete()
end, {
  desc = "Delete current Buffer",
})

--- Mini Visits
vim.keymap.set("n", "<A-i>", function()
  MiniVisits.iterate_paths('forward', vim.fn.getcwd(), {label = ""})
end, {
  desc = "Mini Visits Forward",
})

vim.keymap.set("n", "<A-o>", function()
  MiniVisits.iterate_paths('backward', vim.fn.getcwd(), {label = ""})
end, {
  desc = "MiniVisits Backward",
})

--- Mini Start Session
vim.keymap.set("n", "<leader>sn", function()
  MiniSessions.write()
end, {
  desc = "Start Session Recording",
})
--- Mini Delete Session
vim.keymap.set("n", "<leader>sd", function()
  MiniSessions.delete()
end, {
  desc = "Delete started session",
})

--- MiniMisc Zoom (overwrite Vim Zoom)
vim.keymap.set("n", "<C-w>o", function()
  MiniMisc.zoom()
end, {
  desc = "Toggle Maximize Window",
})

--- Grapple
for c = string.byte('0'), string.byte('9') do
  local key = string.char(c)
  vim.keymap.set('n', '<C-'..key..'>', ':Grapple select index='..key..'<CR>', { noremap = true})
end
vim.keymap.set('n', '<leader>m', ':Grapple toggle<CR>', { noremap = true})
vim.keymap.set('n', 'M', ':Grapple toggle_tags<CR>', { noremap = true})


--- Quicker Quickfix Menu
vim.keymap.set("n", "<leader>c", function()
  require("quicker").toggle()
end, {
  desc = "Toggle quickfix",
})

--- Quicker Loclist Menu
vim.keymap.set("n", "<leader>l", function()
  require("quicker").toggle({ loclist = true })
end, {
  desc = "Toggle loclist",
})

-- Undotree
vim.keymap.set("n", "<leader>u", function()
  require("undotree").toggle()
end, {
  desc = "Toggle Undotree",
})


--- Flash
vim.keymap.set({"n", "x", "o"}, "s", function()
  require("flash").jump()
end, {
  desc = "Flash",
})
vim.keymap.set({"n", "x", "o"}, "S", function()
  require("flash").treesitter()
end, {
  desc = "Flash Treesitter",
})
vim.keymap.set({"o"}, "r", function()
  require("flash").remote()
end, {
  desc = "Flash Remote",
})
vim.keymap.set({"x", "o"}, "R", function()
  require("flash").treesitter_search()
end, {
  desc = "Flash Treesitter Search",
})



