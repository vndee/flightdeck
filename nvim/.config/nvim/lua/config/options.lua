-- Options loaded before lazy.nvim startup. LazyVim sets sensible defaults;
-- only personal overrides live here.
local opt = vim.opt

opt.relativenumber = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.confirm = true
opt.splitkeep = "screen"
opt.timeoutlen = 400

-- Use ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m"
end
