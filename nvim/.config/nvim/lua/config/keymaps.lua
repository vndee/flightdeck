-- Custom keymaps (LazyVim provides most). Add your own below.
local map = vim.keymap.set

-- Center screen after jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Keep selection when indenting in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste over selection without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste (keep register)" })
