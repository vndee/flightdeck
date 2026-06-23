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

-- Steady block cursor in every mode (matches Ghostty: cursor-style = block, blink = false).
-- Default Neovim uses a beam in insert mode; blinkon0 disables blinking.
opt.guicursor = "n-v-c-i-ci-ve-r-cr-o-sm:block-blinkon0"

-- Use ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Follow the system appearance. fish exports FLIGHTDECK_THEME (light/dark); honour
-- it so catppuccin's "auto" flavour is correct even inside tmux, where Neovim's
-- own OSC 11 background detection is unreliable. Without the var (nvim launched
-- outside fish), Neovim's OSC 11 detection still drives the background.
local appearance = vim.env.FLIGHTDECK_THEME
if appearance == "light" or appearance == "dark" then
  opt.background = appearance
end
