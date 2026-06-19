return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
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
