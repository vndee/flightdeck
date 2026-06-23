return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- Follow terminal/system appearance: latte when light, mocha when dark.
      -- Neovim sets vim.o.background from the terminal's OSC 11 response, and
      -- "auto" maps that through the background table below.
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      term_colors = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        which_key = true,
        mason = true,
        native_lsp = { enabled = true },
        snacks = { enabled = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
