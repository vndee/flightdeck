-- Custom autocommands (LazyVim provides good defaults).

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Keep a usable editor window when only side panels remain.
--
-- With Claude Code inline (a terminal split) and Neo-tree open, closing the
-- editor window leaves the layout with no normal window. Neo-tree then absorbs
-- the freed width and balloons; the next file you open from the tree lands in a
-- sliver while Claude gets squished to a few columns (neo-tree's open_file falls
-- back to splitting itself and restoring its own oversized width).
--
-- On a close that leaves only Neo-tree + a terminal, spawn a fresh editor window
-- and restore the panel widths so files always have a full-size home.
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("flightdeck_keep_editor", { clear = true }),
  desc = "Keep an editor window when only Neo-tree + a terminal (Claude) remain",
  callback = function(ev)
    if vim.v.exiting ~= vim.NIL then
      return -- don't interfere while quitting
    end
    local closing = tonumber(ev.match)
    vim.schedule(function()
      local neotree, terminals, has_normal = nil, {}, false
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if w ~= closing and vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_config(w).relative == "" then
          local b = vim.api.nvim_win_get_buf(w)
          local ft, bt = vim.bo[b].filetype, vim.bo[b].buftype
          if ft == "neo-tree" then
            neotree = w
          elseif bt == "terminal" then
            terminals[#terminals + 1] = w
          elseif bt == "" then
            has_normal = true
          end
        end
      end
      -- Only the degenerate case: a terminal panel is open but no editor window.
      if has_normal or #terminals == 0 then
        return
      end
      vim.api.nvim_set_current_win(neotree or terminals[1])
      vim.cmd("rightbelow vsplit | enew")
      -- Restore panel widths so neo-tree / Claude don't hog the row.
      local ok, w = pcall(function()
        return require("neo-tree").config.window.width
      end)
      if neotree and vim.api.nvim_win_is_valid(neotree) then
        vim.api.nvim_win_set_width(neotree, (ok and type(w) == "number") and w or 40)
      end
      for _, t in ipairs(terminals) do
        if vim.api.nvim_win_is_valid(t) then
          vim.api.nvim_win_set_width(t, math.floor(vim.o.columns * 0.30))
        end
      end
    end)
  end,
})
