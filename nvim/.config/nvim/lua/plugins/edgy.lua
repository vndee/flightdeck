-- edgy.nvim owns the cockpit's panel geometry, so `:q` can't strand the layout.
--
-- The base extra (lazyvim.plugins.extras.ui.edgy) pins Neo-tree to the left and
-- adopts snacks terminals onto the edge matching their position. Claude Code
-- opens as a snacks terminal on `split_side = "right"`, so it lands on the right
-- edge automatically. edgy then enforces panel widths and adds "edgy" to
-- neo-tree's open_files_do_not_replace_types — so closing the center editor with
-- `:q` no longer lets the panels balloon, and the next file opens at full width.
--
-- This override just gives the right-edge terminal (Claude) a sensible width.
return {
  {
    "folke/edgy.nvim",
    opts = function(_, opts)
      for _, view in ipairs(opts.right or {}) do
        if view.ft == "snacks_terminal" then
          view.size = { width = 0.3 }
        end
      end
    end,
  },
}
